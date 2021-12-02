//
//  RowOfOrderViewController.swift
//  OrderManagement
//
//  Created by Виталий Шаповалов on 01.12.2021.
//

import UIKit

class RowOfOrderViewController: UIViewController {
    
    var rowOfOrder: RowOfOrder?
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var horizontalServiceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var serviceLabel: UILabel = {
        let label = UILabel()
        label.text = "Service:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var serviceField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 18)
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.keyboardType = .default
        field.borderStyle = .roundedRect
        field.isUserInteractionEnabled = false
        return field
    }()
    
    private lazy var choiceServiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(">", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(choiceService), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var horizontalSumStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.text = "Sum:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sumField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 18)
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.keyboardType = .default
        field.borderStyle = .roundedRect
        field.keyboardType = .numberPad
        return field
    }()
    
    private lazy var emptyButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        title = "Row of Order"
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupRowData()
    }
}

extension RowOfOrderViewController {
    
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
        
        [serviceLabel, serviceField, choiceServiceButton].forEach { horizontalServiceStackView.addArrangedSubview($0) }
        [sumLabel, sumField, emptyButton].forEach { horizontalSumStackView.addArrangedSubview($0) }
        
        [horizontalServiceStackView, horizontalSumStackView].forEach { verticalStackView.addArrangedSubview($0) }
        
        view.addSubview(verticalStackView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            serviceLabel.widthAnchor.constraint(equalToConstant: 65),
            sumLabel.widthAnchor.constraint(equalToConstant: 65)
        ])
        
        NSLayoutConstraint.activate([
            choiceServiceButton.heightAnchor.constraint(equalToConstant: 35),
            choiceServiceButton.widthAnchor.constraint(equalToConstant: 35),
        ])
        
        NSLayoutConstraint.activate([
            emptyButton.heightAnchor.constraint(equalToConstant: 35),
            emptyButton.widthAnchor.constraint(equalToConstant: 35),
        ])
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupRowData() {
        if let rowOfOrder = rowOfOrder {
            serviceField.text = rowOfOrder.service?.name
            sumField.text = "\(rowOfOrder.sum)"
        } else {
            rowOfOrder = RowOfOrder()
        }
    }
    
    private func saveRow() {
        if let rowOfOrder = rowOfOrder {
            rowOfOrder.sum = Float(sumField.text ?? "0") ?? 0
            CoreDataManager.shared.saveContext()
        }
    }
}

extension RowOfOrderViewController {
    
    @objc private func choiceService() {
        let servicesTableVC = ServicesTableViewController()
        servicesTableVC.serviceDidSelect = { [weak self] service in
            if let service = service {
                self?.rowOfOrder?.service = service
                self?.serviceField.text = service.name
            }
        }
        present(UINavigationController(rootViewController: servicesTableVC), animated: true)
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapSaveButton() {
        saveRow()
        dismiss(animated: true, completion: nil)
    }
}
