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
            print("🔥 ALBUMS ENTITIES : \(entities)")
        } catch {
            
        }
    }
    
    func create(body: AlbumBody) {
        do {
            let album = try AlbumRepository.create(body: body)
            self.albums.append(.init(id: album.id, name: album.name, emoji: album.emoji ?? "", color: .red))
            print("🔥 ALBUM : \(album)")
        } catch {
            
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
