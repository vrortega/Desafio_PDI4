//
//  PassengersViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 18/07/24.
//

import UIKit

protocol PassengersViewControllerDelegate: AnyObject {
    func didAddPassengers(_ passengers: [Passenger])
}

class PassengersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var passengers: [Passenger] = []
    weak var delegate: PassengersViewControllerDelegate?
    
    private var viewModel: PassengersViewModel!
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nome"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .alphabet
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let ageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Idade"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let embarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Embarcar", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noPassengersLabel: UILabel = {
        let label = UILabel()
        label.text = "Não tem nenhum passageiro"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let passengersTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PassengersViewModel()
        viewModel.passengers = passengers
        setupBindings()
        
        view.backgroundColor = .white
        title = "Passageiros"
        
        passengersTableView.dataSource = self
        passengersTableView.delegate = self
        passengersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PassengerCell")
        
        setupUIComponents()
        setupConstraints()
        setupEmbarkButtonTarget()
        updateUI()
    }
    
    private func setupBindings() {
        viewModel.passengersDidUpdate = { [weak self] in
            self?.updateUI()
        }
        
        viewModel.showError = { [weak self] errorMessage in
            let alert = UIAlertController(title: "Erro", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupEmbarkButtonTarget() {
        embarkButton.addTarget(self, action: #selector(embarkButtonTapped), for: .touchUpInside)
    }
    
    private func setupUIComponents() {
        view.addSubview(nameTextField)
        view.addSubview(ageTextField)
        view.addSubview(embarkButton)
        view.addSubview(noPassengersLabel)
        view.addSubview(passengersTableView)
    }

    private func setupConstraints() {
        setupNameTextFieldConstraints()
        setupAgeTextFieldConstraints()
        setupEmbarkButtonConstraints()
        setupNoPassengersLabelConstraints()
        setupPassengersTableViewConstraints()
    }
    
    private func setupNameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupAgeTextFieldConstraints() {
        NSLayoutConstraint.activate([
            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            ageTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            ageTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupEmbarkButtonConstraints() {
        NSLayoutConstraint.activate([
            embarkButton.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 16),
            embarkButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            embarkButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            embarkButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupNoPassengersLabelConstraints() {
        NSLayoutConstraint.activate([
            noPassengersLabel.topAnchor.constraint(equalTo: embarkButton.bottomAnchor, constant: 16),
            noPassengersLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            noPassengersLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor)
        ])
    }
    
    private func setupPassengersTableViewConstraints() {
        NSLayoutConstraint.activate([
            passengersTableView.topAnchor.constraint(equalTo: embarkButton.bottomAnchor, constant: 15),
            passengersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passengersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            passengersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func embarkButtonTapped() {
        viewModel.addPassenger(name: nameTextField.text, ageText: ageTextField.text)
        delegate?.didAddPassengers(viewModel.passengers)
    }
    
    private func updateUI() {
        let hasPassengers = !viewModel.passengers.isEmpty
        noPassengersLabel.isHidden = hasPassengers
        passengersTableView.isHidden = !hasPassengers
        passengersTableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPassengers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell", for: indexPath)
        if let passenger = viewModel.passenger(at: indexPath.row) {
            cell.textLabel?.text = "Nome: \(passenger.name), Idade: \(passenger.age)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removePassenger(at: indexPath.row)
        }
    }
}
