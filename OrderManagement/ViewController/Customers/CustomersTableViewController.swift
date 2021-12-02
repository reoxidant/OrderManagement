//
//  CustomersTableViewController.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 30.11.2021.
//

import UIKit
import CoreData

class CustomersTableViewController: UITableViewController {
    
    private let fetchedResultsController = CoreDataManager.shared.fetchedResultsController(entityName: "Customer", keySortDescriptor: "name")
    
    typealias Select = (Customer?) -> ()
    var customerDidSelect: Select?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Customers"
        
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
        
        if let customer = fetchedResultsController.object(at: indexPath) as? Customer {
            cell.textLabel?.text = customer.name
            
            return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let customer = fetchedResultsController.object(at: indexPath) as? Customer
        if let didSelect = customerDidSelect {
            didSelect(customer)
            dismiss(animated: true, completion: nil)
        } else {
            let customerViewController = CustomerViewController()
            customerViewController.customer = fetchedResultsController.object(at: indexPath) as? Customer
            present(UINavigationController(rootViewController: customerViewController), animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let managedObject = fetchedResultsController.object(at: indexPath) as? NSManagedObject {
            CoreDataManager.shared.managedObjectContext.delete(managedObject)
            CoreDataManager.shared.saveContext()
        }
    }
}

extension CustomersTableViewController {
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAddCustomer))
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

extension CustomersTableViewController {
    
    @objc private func didTapAddCustomer() {
        let customerViewController = CustomerViewController()
        present(UINavigationController(rootViewController: customerViewController), animated: true)
    }
}

// MARK: NSFetchedResultsControllerDelegate

extension CustomersTableViewController: NSFetchedResultsControllerDelegate {
    
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
                let customer = fetchedResultsController.object(at: indexPath) as? Customer
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = customer?.name
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
