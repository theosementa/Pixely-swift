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

@MainActor @Observable
public final class AlbumStore {    
    public var albums: [AlbumModel] = []
}

public extension AlbumStore {
    
    func fetchAll() {
        do {
            let entities = try AlbumRepository.fetchAll()
            self.albums = entities.map { $0.toModel() }
        } catch {
            
        }
    }
    
    
    func fetchOneAndUpdate(_ id: UUID) {
        do {
            let album = try AlbumRepository.fetchOne(id: id)
            if let index = self.albums.firstIndex(where: { $0.id == id }) {
                self.albums[index] = album.toModel()
            }
        } catch {
            print("👋 ERROR \(error)")
        }
    }
    
    func create(body: AlbumBody) {
        do {
            let album = try AlbumRepository.create(body: body)
            self.albums.append(album.toModel())
        } catch {
            
        }
    }
    
    func delete(id: UUID) {
        do {
            try AlbumRepository.delete(id: id)
            self.albums.removeAll { $0.id == id }
        } catch {
            
        }
    }
    
    func assetCount(for album: AlbumModel) -> Int {
        do {
            let entity = try AlbumRepository.fetchOne(id: album.id)
            return try AlbumRepository.fetchAssetCount(for: entity)
        } catch {
            return 0
        }
    }

}

// MARK: - Dependencies
@MainActor
struct AlbumStoreKey: @preconcurrency DependencyKey {
    public static let liveValue: AlbumStore = .init()
}

public extension DependencyValues {
    var albumStore: AlbumStore {
        get { self[AlbumStoreKey.self] }
        set { self[AlbumStoreKey.self] = newValue }
    }
}
