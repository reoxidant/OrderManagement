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
    
    class func getRowsOfOrder(order: Order) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RowOfOrder")
        
        let sortDescriptor = NSSortDescriptor(key: "service.name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "%K == %@", "order", order)
        fetchRequest.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }
}
