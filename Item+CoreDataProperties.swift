//
//  Item+CoreDataProperties.swift
//  NotesApp
//
//  Created by Jao Garcia on 3/16/23.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var checked: Bool
    @NSManaged public var title: String?

}

extension Item : Identifiable {

}
