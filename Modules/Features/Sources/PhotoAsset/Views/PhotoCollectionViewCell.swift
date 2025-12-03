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
    
    private let selectionOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    private let checkmarkContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.isHidden = true
        return view
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        imageView.image = UIImage(systemName: "checkmark", withConfiguration: config)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
        contentView.addSubview(selectionOverlay)
        contentView.addSubview(activityIndicator)
        
        // Ajouter le checkmark container
        checkmarkContainer.addSubview(checkmarkImageView)
        contentView.addSubview(checkmarkContainer)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            selectionOverlay.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionOverlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionOverlay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionOverlay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Checkmark container (sélectionné)
            checkmarkContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkmarkContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            checkmarkContainer.widthAnchor.constraint(equalToConstant: 24),
            checkmarkContainer.heightAnchor.constraint(equalToConstant: 24),
            
            checkmarkImageView.centerXAnchor.constraint(equalTo: checkmarkContainer.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: checkmarkContainer.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 14),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    // MARK: - Configuration
    func configure(
        with asset: PHAsset,
        assetDetailed: PHAssetDetailedModel? = nil,
        isSelected: Bool,
        targetSize: CGSize,
        cacheManager: PHCachingImageManager,
        options: PHImageRequestOptions? = nil
    ) -> PHImageRequestID? {
        prepareForReuse()
        activityIndicator.startAnimating()
        
        // Mettre à jour l'état de sélection
        updateSelectionState(isSelected: isSelected)
        
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
    
    private func updateSelectionState(isSelected: Bool) {
        selectionOverlay.isHidden = !isSelected
        checkmarkContainer.isHidden = !isSelected
        
        // Animation légère lors du changement d'état
        if isSelected {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.checkmarkContainer.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.checkmarkContainer.transform = .identity
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        activityIndicator.stopAnimating()
        selectionOverlay.isHidden = true
        checkmarkContainer.isHidden = true
        checkmarkContainer.transform = .identity
    }
}
