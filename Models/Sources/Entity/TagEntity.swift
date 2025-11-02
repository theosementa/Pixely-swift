//
//  TagEntity+CoreDataProperties.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//
//

public import Foundation
public import CoreData

@objc(TagEntity)
public class TagEntity: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEntity> {
        return NSFetchRequest<TagEntity>(entityName: "TagEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var emoji: String?
    @NSManaged public var colorHex: String
    @NSManaged public var assets: Set<AssetDetailedEntity>?

}

// MARK: Generated accessors for assets
extension TagEntity {

    @objc(addAssetsObject:)
    @NSManaged public func addToAssets(_ value: AssetDetailedEntity)

    @objc(removeAssetsObject:)
    @NSManaged public func removeFromAssets(_ value: AssetDetailedEntity)

    @objc(addAssets:)
    @NSManaged public func addToAssets(_ values: NSSet)

    @objc(removeAssets:)
    @NSManaged public func removeFromAssets(_ values: NSSet)

}
