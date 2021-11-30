//
//  Customer+CoreDataClass.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 29.11.2021.
//
//

import Foundation
import CoreData

@objc(Customer)
public class Customer: NSManagedObject {
    convenience init() {
        // Create a new object
        self.init(entity: CoreDataManager.shared.entytiDescription(by: "Customer"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
