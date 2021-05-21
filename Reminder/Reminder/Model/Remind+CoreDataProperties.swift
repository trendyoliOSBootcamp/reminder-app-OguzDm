//
//  Remind+CoreDataProperties.swift
//  Reminder
//
//  Created by Oguz Demırhan on 18.05.2021.
//
//

import Foundation
import CoreData


extension Remind {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Remind> {
        return NSFetchRequest<Remind>(entityName: "Remind")
    }

    @NSManaged public var flagged: Bool
    @NSManaged public var list: String?
    @NSManaged public var notes: String?
    @NSManaged public var priority: String?
    @NSManaged public var title: String?
    @NSManaged public var relation: List?

}

extension Remind : Identifiable {

}
