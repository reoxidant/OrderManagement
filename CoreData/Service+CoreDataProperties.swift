//
//  Service+CoreDataProperties.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 29.11.2021.
//
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var rowsOfOrders: NSSet?

}

// MARK: Generated accessors for rowsOfOrders
extension Service {

    @objc(addRowsOfOrdersObject:)
    @NSManaged public func addToRowsOfOrders(_ value: RowOfOrder)

    @objc(removeRowsOfOrdersObject:)
    @NSManaged public func removeFromRowsOfOrders(_ value: RowOfOrder)

    @objc(addRowsOfOrders:)
    @NSManaged public func addToRowsOfOrders(_ values: NSSet)

    @objc(removeRowsOfOrders:)
    @NSManaged public func removeFromRowsOfOrders(_ values: NSSet)

}

extension Service : Identifiable {

}
