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
    
    let repo: AlbumRepository = .init()
    
}

public extension AlbumStore {
    
    var parentAlbums: [AlbumModel] {
        return self.albums
            .filter { $0.isParentAlbum }
    }
    
    var subAlbums: [SubAlbumModel] {
        var subAlbumIdToParentId: [String: UUID] = [:]
        for parent in self.parentAlbums {
            parent.subAlbumsIds?.forEach { subAlbumId in
                subAlbumIdToParentId[subAlbumId] = parent.id
            }
        }
        
        return albums
            .compactMap { model -> SubAlbumModel? in
                guard let parentId = subAlbumIdToParentId[model.id.uuidString] else {
                    return nil
                }
                return model.toSubAlbum(parentId: parentId)
            }
        
    }
    
}

public extension AlbumStore {
    
    func fetchAll() {
        do {
            let entities = try repo.fetchAll()
            
            self.albums = entities
                .map { $0.toModel() }
        } catch {
            
        }
    }
    
    func fetchOne(id: UUID) -> AlbumModel? {
        return albums.first(where: { $0.id == id })
    }
    
    func fetchSubAlbums(for album: AlbumModel) -> [SubAlbumModel] {
        guard let subAlbumsIds = album.subAlbumsIds else { return [] }
        
        return subAlbums.filter { subAlbum in
            subAlbumsIds.contains(subAlbum.id.uuidString)
        }
    }
    
    func fetchOneAndUpdate(_ id: UUID) {
        do {
            let album = try repo.fetchOne(id: id)
            if let index = self.albums.firstIndex(where: { $0.id == id }) {
                self.albums[index] = album.toModel()
            }
        } catch {
            print("👋 ERROR \(error)")
        }
    }
    
    func create(body: AlbumBody) {
        do {
            let album = try repo.create(body: body)
            self.albums.append(album.toModel())
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func update(body: AlbumBody, isNewParentAlbum: Bool = false) {
        do {
            let updatedAlbum = try repo.update(body: body, isNewParentAlbum: isNewParentAlbum)
            if let index = self.albums.firstIndex(where: { $0.id == updatedAlbum.id }) {
                self.albums[index] = updatedAlbum.toModel()
            }
        } catch {
            
        }
    }
    
    func delete(id: UUID) {
        do {
            try repo.delete(id: id)
            self.albums.removeAll { $0.id == id }
        } catch {
            
        }
    }
    
}

// MARK: - Utils
extension AlbumStore {
    
    public func assetCount(for album: any AlbumProtocol) -> Int {
        do {
            return try repo.fetchAssetCount(for: album)
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
