//
//  InteractiveImageView.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//
// https://github.com/vospennikov/InteractiveImageView?tab=readme-ov-file

import SwiftUI
import UIKit

public struct InteractiveImageView: UIViewRepresentable {
    let image: UIImage
    let maximumZoomScale: CGFloat
    var zoomInteraction: ZoomInteraction

    public struct ZoomInteraction: Equatable {
        public var location: CGPoint
        public var scale: CGFloat
        public var animated: Bool

        public init(location: CGPoint = .zero, scale: CGFloat = 1.0, animated: Bool = true) {
            self.location = location
            self.scale = scale
            self.animated = animated
        }
    }

    public init(
        image: UIImage,
        maximumZoomScale: CGFloat = 1.0,
        zoomInteraction: ZoomInteraction
    ) {
        self.image = image
        self.maximumZoomScale = maximumZoomScale
        self.zoomInteraction = zoomInteraction
    }

    public init(
        image: UIImage,
        maximumZoomScale: CGFloat = 1.0,
        location: CGPoint
    ) {
        self.image = image
        self.maximumZoomScale = maximumZoomScale
        zoomInteraction = .init(location: location)
    }

    public func makeUIView(context: Context) -> InteractiveImage {
        InteractiveImage(image: image, maxScale: maximumZoomScale)
    }

    public func updateUIView(_ uiView: InteractiveImage, context: Context) {
        context.coordinator.update(self, view: uiView)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

public extension InteractiveImageView {
    @MainActor
    final class Coordinator {
        func update(_ representable: InteractiveImageView, view interactiveImage: InteractiveImage) {
            updateZoom(representable, view: interactiveImage)
        }

        private func updateZoom(_ representable: InteractiveImageView, view interactiveImage: InteractiveImage) {
            interactiveImage.zoom(
                to: representable.zoomInteraction.location,
                scale: representable.zoomInteraction.scale,
                animated: representable.zoomInteraction.animated
            )
        }
    }
}

// MARK: - UIKit
public final class InteractiveImage: UIScrollView {
    private var contentView: UIImageView?
    private var imageSize: CGSize = .zero

    public var image: UIImage? {
        didSet {
            if let currentImage = contentView?.image, currentImage == image {
                return
            }
            display(image: image)
        }
    }

    public var maxScale: CGFloat = 1.0

    public init(frame: CGRect = .zero, image: UIImage? = nil, maxScale: CGFloat = 1.0) {
        self.image = image
        imageSize = image?.size ?? .zero
        self.maxScale = maxScale
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = .fast
        contentInsetAdjustmentBehavior = .never
        clipsToBounds = true
        delegate = self
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let image else { return }

        let displayedImage = contentView?.image
        if image != displayedImage {
            display(image: image)
        }

        moveContentToCenter()
    }

    var restorePoint: CGPoint = .zero
    var restoreScale: CGFloat = .leastNonzeroMagnitude
    override public var frame: CGRect {
        willSet {
            if frame != newValue, newValue != .zero, imageSize != .zero {
                restorePoint = pointToCenterAfterRotation()
                restoreScale = scaleToRestoreAfterRotation()
            }
        }
        didSet {
            if frame != oldValue, frame != .zero, imageSize != .zero {
                configure(for: imageSize)
                restoreCenterPoint(to: restorePoint, oldScale: restoreScale)
            }
        }
    }
}

// MARK: - Display content
extension InteractiveImage {
    private func display(image: UIImage?) {
        zoomScale = 1.0

        if let contentView {
            contentView.removeFromSuperview()
        }
        guard let image else {
            contentView?.image = nil
            return
        }

        let contentView = UIImageView(image: image)
        contentView.isUserInteractionEnabled = true
        self.contentView = contentView
        addSubview(contentView)

        configure(for: image.size)
    }

    private func configure(for size: CGSize) {
        imageSize = size
        contentSize = size
        configureZoomScale()
        zoomScale = minimumZoomScale
    }
}

// MARK: - Position
extension InteractiveImage {
    private func moveContentToCenter() {
        guard let contentView else { return }

        let boundsSize = bounds.size
        var frameToCenter = contentView.frame

        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        contentView.frame = frameToCenter
    }
}

// MARK: - Zoom
extension InteractiveImage {
    public func zoom(to point: CGPoint, scale: CGFloat, animated: Bool) {
        guard minimumZoomScale != maximumZoomScale,
              minimumZoomScale < maximumZoomScale
        else { return }

        let scale: CGFloat = if zoomScale == minimumZoomScale {
            min(maximumZoomScale, scale)
        } else {
            minimumZoomScale
        }

        let contentLocation = convert(point, to: contentView)
        let zoomRect = makeZoomRect(for: scale, with: contentLocation)

        zoom(to: zoomRect, animated: animated)
    }

    private func makeZoomRect(for scale: CGFloat, with center: CGPoint) -> CGRect {
        var zoomRect: CGRect = .zero
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        zoomRect.origin.x = center.x - zoomRect.size.width / 2
        zoomRect.origin.y = center.y - zoomRect.size.height / 2
        return zoomRect
    }

    private func configureZoomScale() {
        guard imageSize != .zero else { return }
        
        let xScale = bounds.size.width / imageSize.width
        let yScale = bounds.size.height / imageSize.height
        var minScale = max(min(xScale, yScale), .ulpOfOne)
        
        if minScale > maxScale {
            minScale = maxScale
        }
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
    }
}

// MARK: - Device rotation
extension InteractiveImage {
    private func restoreCenterPoint(to oldCenter: CGPoint, oldScale: CGFloat) {
        zoomScale = min(maximumZoomScale, max(minimumZoomScale, oldScale))

        let boundsCenter = convert(oldCenter, from: contentView)
        var offset = CGPoint(x: boundsCenter.x - bounds.size.width / 2, y: boundsCenter.y - bounds.size.height / 2)

        let maxOffset = maximumContentOffset()
        let minOffset = minimumContentOffset()
        offset.x = max(minOffset.x, min(maxOffset.x, offset.x))
        offset.y = max(minOffset.y, min(maxOffset.y, offset.y))

        contentOffset = offset
    }

    private func pointToCenterAfterRotation() -> CGPoint {
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        return convert(boundsCenter, to: contentView)
    }

    private func scaleToRestoreAfterRotation() -> CGFloat {
        var contentScale = zoomScale
        if contentScale <= minimumZoomScale + .ulpOfOne {
            contentScale = 0
        }
        return contentScale
    }

    private func maximumContentOffset() -> CGPoint {
        let contentSize = contentSize
        let boundSize = bounds.size
        return CGPoint(x: contentSize.width - boundSize.width, y: contentSize.height - boundSize.height)
    }

    private func minimumContentOffset() -> CGPoint {
        .zero
    }
}

// MARK: - UIScrollViewDelegate
extension InteractiveImage: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        moveContentToCenter()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        moveContentToCenter()
    }
}
