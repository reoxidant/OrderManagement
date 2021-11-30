//
//  AppDelegate.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 29.11.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            // Create a new object
            let managedObject = Customer()
            
            // Set value attribute
            managedObject.name = "Microsoft"
            
            // Get value from attrubute
            let name = managedObject.name
            print("name = \(name!)")
            
            // Write the NSObjectModel to database
            // self.saveContext()
            
            // Fetch NSObjectModel from database
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
            do {
                let results = try CoreDataManager.shared.managedObjectContext.fetch(fetchRequest) as! [Customer]
                for result in results {
                    let value = result.name!
                    if value == "" {
                        CoreDataManager.shared.managedObjectContext.delete(result)
                        self.saveContext()
                    }
                    print("name - \(value)")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OrderManagement")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

