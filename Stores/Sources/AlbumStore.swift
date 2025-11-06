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
import Utilities

@MainActor @Observable
public final class AlbumStore {    
    public var albums: [AlbumModel] = []
    public var parentAlbums: [AlbumModel] = []
    public var subAlbums: [SubAlbumModel] = []
}

public extension AlbumStore {
    
    func fetchAll() {
        do {
            let entities = try AlbumRepository.fetchAll()
            
            self.albums = entities.map { $0.toModel() }
            
            self.parentAlbums = entities
                .filter { $0.isParentAlbum }
                .map { $0.toModel() }
            
            var subAlbumIdToParentId: [String: UUID] = [:]
            for parent in self.parentAlbums {
                parent.subAlbumsIds?.forEach { subAlbumId in
                    subAlbumIdToParentId[subAlbumId] = parent.id
                }
            }
            
            self.subAlbums = entities
                .compactMap { entity -> SubAlbumModel? in
                    guard let parentId = subAlbumIdToParentId[entity.id.uuidString] else {
                        return nil
                    }
                    return entity.toSubAlbum(parentId: parentId)
                }
        } catch {

        }
    }
    
    func fetchOne(id: UUID) -> AlbumModel? {
        return albums.first(where: { $0.id == id })
    }
    
    func fetchSubAlbums(for album: AlbumModel) -> [SubAlbumModel] {
        guard let subAlbumsIds = album.subAlbumsIds else {
            return []
        }
        
        return subAlbums.filter { subAlbum in
            subAlbumsIds.contains(subAlbum.id.uuidString)
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
