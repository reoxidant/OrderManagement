//
//  Order+CoreDataProperties.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 29.11.2021.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var date: Date?
    @NSManaged public var made: Bool
    @NSManaged public var paid: Bool
    @NSManaged public var customer: Customer?
    @NSManaged public var rowsOfOrder: NSSet?

}

// MARK: Generated accessors for rowsOfOrder
extension Order {

    @objc(addRowsOfOrderObject:)
    @NSManaged public func addToRowsOfOrder(_ value: RowOfOrder)

    @objc(removeRowsOfOrderObject:)
    @NSManaged public func removeFromRowsOfOrder(_ value: RowOfOrder)

    @objc(addRowsOfOrder:)
    @NSManaged public func addToRowsOfOrder(_ values: NSSet)

    @objc(removeRowsOfOrder:)
    @NSManaged public func removeFromRowsOfOrder(_ values: NSSet)

}

extension Order : Identifiable {

}
