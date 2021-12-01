//
//  RowOfOrder+CoreDataClass.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 29.11.2021.
//
//

import Foundation
import CoreData

@objc(RowOfOrder)
public class RowOfOrder: NSManagedObject {
    convenience init() {
        // Create a new object
        self.init(entity: CoreDataManager.shared.entytiDescription(by: "RowOfOrder"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
