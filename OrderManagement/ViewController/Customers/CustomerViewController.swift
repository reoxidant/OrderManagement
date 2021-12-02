//
//  CustomerViewController.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 30.11.2021.
//

import UIKit
import CloudKit

class CustomerViewController: UIViewController {
    
    var customer: Customer?
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var verticalLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        return label
    }()
    
    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 18)
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.keyboardType = .default
        field.borderStyle = .roundedRect
        field.placeholder = "type customer name"
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return field
    }()
    
    private lazy var verticalFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Info:"
        return label
    }()
    
    private lazy var infoField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 18)
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.keyboardType = .default
        field.borderStyle = .roundedRect
        field.placeholder = "type customer info"
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupCustomer()
    }
}

extension CustomerViewController {
    
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
        
        [nameLabel, infoLabel].forEach { verticalLabelsStackView.addArrangedSubview($0) }
        [nameField, infoField].forEach { verticalFieldsStackView.addArrangedSubview($0) }
        
        [verticalLabelsStackView, verticalFieldsStackView].forEach { horizontalStackView.addArrangedSubview($0) }
        
        view.addSubview(horizontalStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupCustomer() {
        // Reading object
        if let customer = customer {
            title = "Editing the customer"
            nameField.text = customer.name
            infoField.text = customer.info
        } else {
            title = "Creating a new customer"
        }
    }
    
    private func saveCustomer() -> Bool {
        // Validation of required fields
        guard let nameText = nameField.text, !nameText.isEmpty else {
            let alert = UIAlertController(title: "Validation error!", message: "Fill the name of customer", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return false
        }
        
        // Creating object
        if customer == nil {
            customer = Customer()
        }
        
        // Saving object
        if let customer = customer {
            customer.name = nameField.text
            customer.info = infoField.text
            CoreDataManager.shared.saveContext()
        }
        
        return true
    }
}

extension CustomerViewController {
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        if saveCustomer() {
            dismiss(animated: true)
        }
    }
}
