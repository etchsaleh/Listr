//
//  ItemType+CoreDataProperties.swift
//  DreamListr
//
//  Created by Hesham Saleh on 1/29/17.
//  Copyright © 2017 Hesham Saleh. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
