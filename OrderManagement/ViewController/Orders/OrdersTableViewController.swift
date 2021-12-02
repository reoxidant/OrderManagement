//
//  OrdersTableViewController.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 01.12.2021.
//

import UIKit
import CoreData

class OrdersTableViewController: UITableViewController {
    
    private let fetchedResultsController = CoreDataManager.shared.fetchedResultsController(entityName: "Order", keySortDescriptor: "date")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Orders"

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
        
        if let order = fetchedResultsController.object(at: indexPath) as? Order {
            
            configureCell(cell, order: order)
            return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let orderViewController = OrderViewController()
        orderViewController.order = fetchedResultsController.object(at: indexPath) as? Order
        present(UINavigationController(rootViewController: orderViewController), animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let managedObject = fetchedResultsController.object(at: indexPath) as? NSManagedObject {
            CoreDataManager.shared.managedObjectContext.delete(managedObject)
            CoreDataManager.shared.saveContext()
        }
    }
}

extension OrdersTableViewController {
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAddOrder))
    }
    
    private func setupFetchedResultsController() {
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func configureCell(_ cell: UITableViewCell, order: Order) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let formatterString = formatter.string(from: order.date ?? Date())
        let nameOfCustomer = order.customer?.name ?? "-- Unknown --"
        cell.textLabel?.text = formatterString + "\t" + nameOfCustomer
    }
}

extension OrdersTableViewController {
    @objc private func didTapAddOrder() {
        let orderViewController = OrderViewController()
        present(UINavigationController(rootViewController: orderViewController), animated: true)
    }
}

extension OrdersTableViewController: NSFetchedResultsControllerDelegate {
    
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
            if let indexPath = indexPath,
                let cell = tableView.cellForRow(at: indexPath), let order = fetchedResultsController.object(at: indexPath) as? Order {
                configureCell(cell, order: order)
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
