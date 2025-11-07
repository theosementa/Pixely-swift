//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Models
import Repositories
import Dependencies
import Persistence

@MainActor @Observable
public final class AssetDetailedStore {
    public var assets: [PHAssetDetailedModel] = []
    
    @ObservationIgnored
    @Dependency(\.albumStore) private var albumStore
}

public extension AssetDetailedStore {
    
    @MainActor
    func fetchAll() {
        do {
            let assets = try AssetDetailedRepository.fetchAll()
            self.assets = assets
                .map { $0.toModel() }
        } catch {
            
        }
    }
    
    @MainActor
    func create(_ body: AssetDetailledBody) {
        do {
            let asset = try AssetDetailedRepository.create(body: body)
            self.assets.append(asset.toModel())
            if let albumId = body.album?.id {
                albumStore.fetchOneAndUpdate(albumId)
            }
        } catch {
            print("👋 ERROR \(error)")
        }
    }
    
    @MainActor
    func updateAlbum(_ assetEntity: AssetDetailedEntity, newAlbumId: UUID) {
        do {
            if let assetEntity = try AssetDetailedRepository.fetchOneEntity(phAssetId: assetEntity.assetId) {
                let albumEntity = try AlbumRepository.fetchOne(id: newAlbumId)
                assetEntity.album = albumEntity
                
                try CoreDataStack.shared.viewContext.save()
                albumStore.fetchOneAndUpdate(newAlbumId)
                
                if let index = assets.firstIndex(where: { $0.assetId == assetEntity.assetId }) {
                    self.assets[index] = assetEntity.toModel()
                }
            }
        } catch {
            print("👋 ERROR \(error)")
        }
    }
    
    func fetchOneEntity(phAssetId: String) -> AssetDetailedEntity? {
        do {
            return try AssetDetailedRepository.fetchOneEntity(phAssetId: phAssetId)
        } catch {
            return nil
        }
    }
    
}

public extension AssetDetailedStore {
    
    func findOneBy(_ assetId: String) -> PHAssetDetailedModel? {
        return assets.first { $0.assetId == assetId }
    }
    
}

// MARK: - Dependencies
@MainActor
struct AssetDetailedKey: @preconcurrency DependencyKey {
    public static let liveValue: AssetDetailedStore = .init()
}

public extension DependencyValues {
    var assetDetailedStore: AssetDetailedStore {
        get { self[AssetDetailedKey.self] }
        set { self[AssetDetailedKey.self] = newValue }
    }
}
