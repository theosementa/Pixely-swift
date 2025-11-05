//
//  AssetDetailledEntity+CoreDataProperties.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//
//

public import Foundation
public import CoreData

@objc(AssetDetailedEntity)
public class AssetDetailedEntity: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssetDetailedEntity> {
        return NSFetchRequest<AssetDetailedEntity>(entityName: "AssetDetailedEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var assetId: String
    @NSManaged public var title: String?
    @NSManaged public var legend: String?
    @NSManaged public var fileSize: Int64
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var software: String?
    @NSManaged public var dateTime: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var focal: Int64
    @NSManaged public var opening: String?
    @NSManaged public var pixelWidth: Int64
    @NSManaged public var pixelHeight: Int64
    @NSManaged public var album: AlbumEntity?
    @NSManaged public var tags: Set<TagEntity>?

}

// MARK: Generated accessors for tags
extension AssetDetailedEntity {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagEntity)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagEntity)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension AssetDetailedEntity {
    
    public func toModel() -> PHAssetDetailedModel {
        return .init(
            assetId: self.assetId,
            model: self.model,
            make: self.make,
            software: self.software,
            dateTime: self.dateTime,
            latitude: self.latitude,
            longitude: self.longitude,
            focal: Int(self.focal),
            opening: self.opening,
            fileSize: Int(self.fileSize),
            pixelWidth: Int(self.pixelWidth),
            pixelHeight: Int(self.pixelHeight)
        )
    }
    
}
