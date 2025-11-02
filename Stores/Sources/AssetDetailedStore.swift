//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Models
import Repositories

@MainActor @Observable
public final class AssetDetailedStore {
    public static let shared = AssetDetailedStore()
    
    public var assets: [AssetDetailedEntity] = []
}

public extension AssetDetailedStore {
    
    func create(albumId: UUID) {
        do {
            let asset = try AssetDetailedRepository.create(body: .init(albumId: albumId))
            print("🔥 ASSET : \(asset)")
        } catch {
            
        }
    }
    
}

public extension AssetDetailedStore {
    
    func findOneBy(_ assetId: String) -> AssetDetailedEntity? {
        return assets.first { $0.assetId == assetId }
    }
    
}
