//
//  Service+CoreDataClass.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 29.11.2021.
//
//

import Foundation
import CoreData

@objc(Service)
public class Service: NSManagedObject {
    convenience init() {
        // Create a new object
        self.init(entity: CoreDataManager.shared.entytiDescription(by: "Service"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
