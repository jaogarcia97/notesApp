//
//  ItemEntity+CoreDataProperties.swift
//  NotesApp
//
//  Created by Jao Garcia on 3/16/23.
//
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var title: Int64
    @NSManaged public var checked: Bool

}

extension ItemEntity : Identifiable {

}
