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
    
    weak var delegate: PassengersViewControllerDelegate?
    
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
    
    var passengers: [Passenger] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Passageiros"
        
        passengersTableView.dataSource = self
        passengersTableView.delegate = self
        passengersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PassengerCell")
        
        setupLayout()
        updateUI()
    }
    
    private func setupLayout() {
        view.addSubview(nameTextField)
        view.addSubview(ageTextField)
        view.addSubview(embarkButton)
        view.addSubview(noPassengersLabel)
        view.addSubview(passengersTableView)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 35),
            
            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            ageTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            ageTextField.heightAnchor.constraint(equalToConstant: 35),
            
            embarkButton.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 16),
            embarkButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            embarkButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            embarkButton.heightAnchor.constraint(equalToConstant: 44),
            
            noPassengersLabel.topAnchor.constraint(equalTo: embarkButton.bottomAnchor, constant: 16),
            noPassengersLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            noPassengersLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            passengersTableView.topAnchor.constraint(equalTo: embarkButton.bottomAnchor, constant: 15),
            passengersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            passengersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            passengersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
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
        
        delegate?.didAddPassengers(passengers)
        
    }
    
    private func updateUI() {
        noPassengersLabel.isHidden = !passengers.isEmpty
        passengersTableView.isHidden = passengers.isEmpty
        passengersTableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell", for: indexPath)
        let passenger = passengers[indexPath.row]
        cell.textLabel?.text = "Nome: \(passenger.name), Idade: \(passenger.age)"
        return cell
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            passengers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateUI()
            delegate?.didAddPassengers(passengers)
        }
    }
}


