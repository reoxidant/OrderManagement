//
//  Order+CoreDataClass.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 29.11.2021.
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    convenience init() {
        // Create a new object
        self.init(entity: CoreDataManager.shared.entytiDescription(by: "Order"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
