//
//  List+CoreDataProperties.swift
//  Reminder
//
//  Created by Oguz Demırhan on 18.05.2021.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var color: String?
    @NSManaged public var count: Int16
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var relation: NSSet?

}

// MARK: Generated accessors for relation
extension List {

    @objc(addRelationObject:)
    @NSManaged public func addToRelation(_ value: Remind)

    @objc(removeRelationObject:)
    @NSManaged public func removeFromRelation(_ value: Remind)

    @objc(addRelation:)
    @NSManaged public func addToRelation(_ values: NSSet)

    @objc(removeRelation:)
    @NSManaged public func removeFromRelation(_ values: NSSet)

}

extension List : Identifiable {

}
