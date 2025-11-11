//
//  PhotoCollectionViewCell.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import UIKit
import Photos
import SwiftUI
import Models

class PhotoCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
//    private let albumLabelView: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        label.textColor = .white
//        label.clipsToBounds = true
//        label.layer.cornerRadius = 12
//        return label
//    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
//        contentView.addSubview(albumLabelView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Position the album icon in the bottom right corner with padding
//            albumLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
//            albumLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
//            albumLabelView.widthAnchor.constraint(equalToConstant: 24),
//            albumLabelView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Add padding inside the album icon
//        let iconPadding: CGFloat = 4
//        albumLabelView.layoutMargins = UIEdgeInsets(top: iconPadding, left: iconPadding, bottom: iconPadding, right: iconPadding)
    }
    
    // MARK: - Configuration
    func configure(
        with asset: PHAsset,
        assetDetailed: PHAssetDetailedModel? = nil,
        targetSize: CGSize,
        cacheManager: PHCachingImageManager,
        options: PHImageRequestOptions? = nil
    ) -> PHImageRequestID? {
        prepareForReuse()
        activityIndicator.startAnimating()
        
//        if let assetDetailed, let album = assetDetailed.album, album != .noAlbum {
//            albumLabelView.text = album.emoji
//            albumLabelView.backgroundColor = UIColor(album.color)
//            albumLabelView.isHidden = false
//        } else {
//            albumLabelView.isHidden = true
//        }
        
        return cacheManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { [weak self] (image, info) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                let isPlaceholder = (info?[PHImageResultIsInCloudKey] as? Bool) ?? false
                
                if !isDegraded && !isPlaceholder {
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                } else if isDegraded {
                    self.imageView.image = image
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        activityIndicator.stopAnimating()
//        albumLabelView.isHidden = true
    }
}
