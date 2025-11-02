//
//  File.swift
//  Repositories
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import CoreData
import Persistence
import Models

public protocol RepositoryProtocol {
    associatedtype Entity: NSManagedObject
    associatedtype BodyObject: BodyProtocol
        
    static func create(body: BodyObject) throws -> Entity
    static func update(body: BodyObject) throws -> Entity
}

extension RepositoryProtocol {
    
    public static func fetchAll() throws -> [Entity] {
        let request = Entity.fetchRequest()
        return try CoreDataStack.shared.viewContext.fetch(request) as? [Entity] ?? []
    }
    
    public static func fetchOne(id: UUID) throws -> Entity {
        let request = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        let results = try CoreDataStack.shared.viewContext.fetch(request)
        
        guard let entity = results.first as? Entity else {
            throw RepositoryError.notFound
        }
        
        return entity
    }
    
    public static func delete(id: UUID) throws {
        let entity = try fetchOne(id: id)
        CoreDataStack.shared.viewContext.delete(entity)
        try CoreDataStack.shared.viewContext.save()
    }
    
}
