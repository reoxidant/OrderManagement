//
//  ServicesTableTableViewController.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 01.12.2021.
//

import UIKit
import CoreData

class ServicesTableViewController: UITableViewController {
    
    typealias Select = (Service?) -> ()
    var serviceDidSelect: Select?
    
    private let fetchedResultsController = CoreDataManager.shared.fetchedResultsController(entityName: "Service", keySortDescriptor: "name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Services"
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupFetchedResultsController()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if let service = fetchedResultsController.object(at: indexPath) as? Service {
            
            cell.textLabel?.text = service.name
            
            return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let service = fetchedResultsController.object(at: indexPath) as? Service
        if let didSelect = serviceDidSelect {
            didSelect(service)
            dismiss(animated: true, completion: nil)
        } else {
            let serviceViewController = ServiceViewController()
            serviceViewController.service = fetchedResultsController.object(at: indexPath) as? Service
            present(UINavigationController(rootViewController: serviceViewController), animated: true)
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let managedObject = fetchedResultsController.object(at: indexPath) as? NSManagedObject {
            CoreDataManager.shared.managedObjectContext.delete(managedObject)
            CoreDataManager.shared.saveContext()
        }
    }
}

extension ServicesTableViewController {
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAddService))
    }
    
    private func setupFetchedResultsController() {
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension ServicesTableViewController {
    @objc private func didTapAddService() {
        let serviceViewController = ServiceViewController()
        present(UINavigationController(rootViewController: serviceViewController), animated: true)
    }
}

extension ServicesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let service = fetchedResultsController.object(at: indexPath) as? Service
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = service?.name
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
