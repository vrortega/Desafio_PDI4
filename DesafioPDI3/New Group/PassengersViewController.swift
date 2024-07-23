//
//  PassengersViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 18/07/24.
//

import UIKit

protocol PassengersViewControllerDelegate: AnyObject {
    func didUpdatePassengers(_ passengers: [Passenger])
}

class PassengersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: PassengersViewControllerDelegate?
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nome"
        textField.borderStyle = .roundedRect
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
        button.addTarget(self, action: #selector(embarkButtonTapped), for: .touchUpInside)
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
    
    private var passengers: [Passenger] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Passageiros"
        
        passengersTableView.dataSource = self
        passengersTableView.delegate = self
        passengersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PassengerCell")
        
        setupLayout()
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, ageTextField, embarkButton, noPassengersLabel, passengersTableView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            ageTextField.heightAnchor.constraint(equalToConstant: 44),
            embarkButton.heightAnchor.constraint(equalToConstant: 44),
            passengersTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func embarkButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let ageText = ageTextField.text, !ageText.isEmpty,
              let age = Int(ageText) else {
            let alert = UIAlertController(title: "Erro", message: "Por favor, insira um nome e uma idade válidos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let newPassenger = Passenger(name: name, age: age)
        
        if newPassenger.isMinor {
            let alert = UIAlertController(title: "Erro", message: "Passageiro menor de idade não pode embarcar.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        passengers.append(newPassenger)
        nameTextField.text = ""
        ageTextField.text = ""
        updateUI()
    }
    
    private func updateUI() {
        noPassengersLabel.isHidden = !passengers.isEmpty
        passengersTableView.isHidden = passengers.isEmpty
        passengersTableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell", for: indexPath)
        let passenger = passengers[indexPath.row]
        cell.textLabel?.text = "Nome: \(passenger.name), Idade: \(passenger.age)"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            passengers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateUI()
        }
    }
}


