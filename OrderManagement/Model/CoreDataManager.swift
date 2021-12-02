//
//  CoreDataManager.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 29.11.2021.
//

import CoreData
import Foundation
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    // Entity description
    
    func entytiDescription(by name: String) -> NSEntityDescription {
        NSEntityDescription.entity(forEntityName: name, in: managedObjectContext)!
    }
    
    // Fetched Results Controller by Entity Name
    
    func fetchedResultsController(entityName: String, keySortDescriptor: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keySortDescriptor, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest,
                                                                                        managedObjectContext: CoreDataManager.shared.managedObjectContext,
                                                                                        sectionNameKeyPath: nil,
                                                                                        cacheName: nil)
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
