//
//  ReportTableViewController.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 01.12.2021.
//

import UIKit
import CoreData

class ReportTableViewController: UITableViewController {
    
    private var fetchRequest: NSFetchRequest<Order> = {
        let fetchRequest = NSFetchRequest<Order>(entityName: "Order")
        
        // Sort Descriptor
        let sortDescriptorDate = NSSortDescriptor(key: "date", ascending: true)
        let sortDescriptorCustomerName = NSSortDescriptor(key: "customer.name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorDate, sortDescriptorCustomerName]
        
        // Predicate
        let predicate = NSPredicate(format: "%K == true AND %K == false", "made", "paid")
        fetchRequest.predicate = predicate
        
        return fetchRequest
    }()
    
    var report: [Order]?

    override func viewDidLoad() {
        super.viewDidLoad()
   
        title = "Orders report"
        
        setupReport()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let report = report {
            return report.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if let report = report {
            let order = report[indexPath.row]
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            let nameOfCustomer = order.customer?.name ?? "-- Unknown --"
            cell.textLabel?.text = formatter.string(from: order.date ?? Date()) + "\t" + nameOfCustomer
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ReportTableViewController {
    
    private func setupReport() {
        
        do {
            report = try CoreDataManager.shared.managedObjectContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
