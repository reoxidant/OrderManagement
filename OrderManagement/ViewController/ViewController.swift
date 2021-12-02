//
//  ViewController.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 29.11.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var customersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Customers", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(showCustomers), for: .touchUpInside)
        return button
    }()
    
    private lazy var servicesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Services", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(showServices), for: .touchUpInside)
        return button
    }()
    
    private lazy var documentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Documents", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(showDocuments), for: .touchUpInside)
        return button
    }()
    
    private lazy var ordersReportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Orders report", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(showReports), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }
}

extension ViewController {
    
    private func setupNavigationBar() {
        title = "Order Management"
        
        if #available(iOS 13.0, *) {
            let apperance = UINavigationBarAppearance()
            apperance.configureWithDefaultBackground()
            
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.standardAppearance = apperance
            navigationController?.navigationBar.scrollEdgeAppearance = apperance
        }
    }
    
    private func setupViews() {
        [customersButton, servicesButton, documentsButton, ordersReportButton].forEach({ verticalStackView.addArrangedSubview($0) })
        view.addSubview(verticalStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStackView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}

extension ViewController {
    @objc private func showCustomers() {
        navigationController?.pushViewController(CustomersTableViewController(), animated: true)
    }
    
    @objc private func showServices() {
        navigationController?.pushViewController(ServicesTableViewController(), animated: true)
    }
    
    @objc private func showDocuments() {
        navigationController?.pushViewController(OrdersTableViewController(), animated: true)
    }
    
    @objc private func showReports() {
        navigationController?.pushViewController(ReportTableViewController(), animated: true)
    }
}

