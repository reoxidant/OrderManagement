//
//  OrderViewController.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 01.12.2021.
//

import UIKit
import CoreData

class OrderViewController: UIViewController {
    
    var order: Order?
    var tableFetchedResults: NSFetchedResultsController<RowOfOrder>?
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru")
        datePicker.timeZone = .current
        return datePicker
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var horizontalCustomerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var horizontalMadeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var horizontalPaidStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var horizontalOrderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var customerLabel: UILabel = {
        let label = UILabel()
        label.text = "Customer:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var customerField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 18)
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.keyboardType = .default
        field.borderStyle = .roundedRect
        field.isUserInteractionEnabled = false
        return field
    }()
    
    private lazy var choiceCustomerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(">", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(choiceCustomer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var madeLabel: UILabel = {
        let label = UILabel()
        label.text = "Made:"
        return label
    }()
    
    private lazy var switchMade: UISwitch = {
        let switchMade = UISwitch()
        return switchMade
    }()
    
    private lazy var paidLabel: UILabel = {
        let label = UILabel()
        label.text = "Paid:"
        return label
    }()
    
    private lazy var switchPaid: UISwitch = {
        let switchPaid = UISwitch()
        return switchPaid
    }()
    
    private lazy var rowsOrderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Rows of Order"
        return label
    }()
    
    private lazy var addRowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Row", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.addTarget(self, action: #selector(addRowOfOrder), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .tertiarySystemGroupedBackground
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupOrderData()
    }
}

extension OrderViewController {
    
    private func setupNavigationBar() {
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSaveButton))
    }
    
    private func setupViews() {
        
        [customerLabel, customerField, choiceCustomerButton].forEach { horizontalCustomerStackView.addArrangedSubview($0) }
        [madeLabel, switchMade].forEach { horizontalMadeStackView.addArrangedSubview($0) }
        [paidLabel, switchPaid].forEach { horizontalPaidStackView.addArrangedSubview($0) }
        [rowsOrderLabel, addRowButton].forEach { horizontalOrderStackView.addArrangedSubview($0) }
        
        [horizontalCustomerStackView, horizontalMadeStackView, horizontalPaidStackView, horizontalOrderStackView].forEach { verticalStackView.addArrangedSubview($0) }
        
        view.addSubview(datePicker)
        view.addSubview(verticalStackView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            customerLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            choiceCustomerButton.heightAnchor.constraint(equalToConstant: 35),
            choiceCustomerButton.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupOrderData() {
        // Creating object
        if order == nil {
            order = Order()
            order?.date = Date()
        }
        
        if let order = order {
            
            if let customerName = order.customer?.name {
                title = "Editing the \(customerName)'s order"
            } else {
                title = "Editing a created order"
            }
            
            datePicker.date = order.date ?? Date()
            switchMade.isOn = order.made
            switchPaid.isOn = order.paid
            customerField.text = order.customer?.name
            
            tableFetchedResults = Order.getRowsOfOrder(order: order)
            tableFetchedResults?.delegate = self
            
            do {
                try tableFetchedResults?.performFetch()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveOrder() {
        if let order = order {
            order.date = datePicker.date
            order.made = switchMade.isOn
            order.paid = switchPaid.isOn
            CoreDataManager.shared.saveContext()
        }
    }
}

extension OrderViewController {
    
    @objc private func choiceCustomer() {
        let customersTableVC = CustomersTableViewController()
        customersTableVC.customerDidSelect = { [weak self] customer in
            if let customer = customer {
                // customer.addToOrders(order)
                self?.order?.customer = customer
                self?.customerField.text = customer.name
            }
        }
        present(UINavigationController(rootViewController: customersTableVC), animated: true)
    }
    
    @objc private func addRowOfOrder() {
        if let order = order {
            let newRowOfOrder = RowOfOrder()
            //newRowOfOrder.order = order
            order.addToRowsOfOrder(newRowOfOrder)
            let rowsOfOrderVC = RowOfOrderViewController()
            rowsOfOrderVC.rowOfOrder = newRowOfOrder
            present(UINavigationController(rootViewController: rowsOfOrderVC), animated: true)
        }
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        saveOrder()
        dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource

extension OrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = tableFetchedResults?.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowOfOrder = tableFetchedResults?.object(at: indexPath)
        let nameOfService = rowOfOrder?.service?.name ?? "-- Unknown --"
        let cell = UITableViewCell()
        cell.textLabel?.text = nameOfService + " - " + "\(rowOfOrder?.sum ?? 0)"
        return cell
    }
}

// MARK: UITableViewDelegate

extension OrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let managedObject = tableFetchedResults?.object(at: indexPath) {
            CoreDataManager.shared.managedObjectContext.delete(managedObject)
            CoreDataManager.shared.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let rowOfVC = RowOfOrderViewController()
        rowOfVC.rowOfOrder = tableFetchedResults?.object(at: indexPath)
        present(UINavigationController(rootViewController: rowOfVC), animated: true)
    }
}

// MARK: NSFetchedResultsControllerDelegate

extension OrderViewController: NSFetchedResultsControllerDelegate {
    
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
                let cell = tableView.cellForRow(at: indexPath),
                let rowOfOrder = tableFetchedResults?.object(at: indexPath) as? RowOfOrder {
                
                let nameOfService = rowOfOrder.service?.name ?? "-- Unknown --"
                cell.textLabel?.text = nameOfService + " - " + "\(rowOfOrder.sum)"
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
