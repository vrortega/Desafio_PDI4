///
//  NewFlightViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 17/07/24.
//

import Foundation
import UIKit

class NewFlightViewController: UIViewController {

    // MARK: - UI Components

    private let originTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Origem"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let destinationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Destino"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let capacityLabel: UILabel = {
        let label = UILabel()
        label.text = "Capacidade de 1 pessoa(s)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.value = 1
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
    private let peopleIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let originIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "airplane.departure"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let destinationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "airplane.arrival"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let departureDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Data de ida"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let returnDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Data de volta"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let departureDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let returnDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let oneWayLabel: UILabel = {
        let label = UILabel()
        label.text = "Somente ida"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let oneWaySwitch: UISwitch = {
        let oneWaySwitch = UISwitch()
        oneWaySwitch.translatesAutoresizingMaskIntoConstraints = false
        return oneWaySwitch
    }()
    
    private let calendarIcon1: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let calendarIcon2: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let passengerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let crewView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let passengerLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum passageiro adicionado"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let crewLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum tripulante adicionado"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightArrowIcon1: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let rightArrowIcon2: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let personIcon1: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let personIcon2: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let takeoffButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Decolar", for: .normal)
        button.setImage(UIImage(systemName: "airplane"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(takeoffButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data Models
    
    private var passengers: [Passenger] = []
    private var pilots: [Pilot] = []
    private var coPilots: [CoPilot] = []
    private var flightAttendants: [FlightAttendant] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Novo Voo"
        
        setupLayout()
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
           let passengerTapGesture = UITapGestureRecognizer(target: self, action: #selector(passengerViewTapped))
           passengerView.addGestureRecognizer(passengerTapGesture)
           
           let crewTapGesture = UITapGestureRecognizer(target: self, action: #selector(crewViewTapped))
           crewView.addGestureRecognizer(crewTapGesture)
       }
       
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        let originStackView = UIStackView(arrangedSubviews: [originIcon, originTextField])
        originStackView.axis = .horizontal
        originStackView.spacing = 8
        originStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let destinationStackView = UIStackView(arrangedSubviews: [destinationIcon, destinationTextField])
        destinationStackView.axis = .horizontal
        destinationStackView.spacing = 8
        destinationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let capacityStackView = UIStackView(arrangedSubviews: [peopleIcon, capacityLabel, stepper])
        capacityStackView.axis = .horizontal
        capacityStackView.spacing = 8
        capacityStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let departureDateStackView = UIStackView(arrangedSubviews: [calendarIcon1, departureDateLabel, departureDatePicker])
        departureDateStackView.axis = .horizontal
        departureDateStackView.spacing = 8
        departureDateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let returnDateStackView = UIStackView(arrangedSubviews: [calendarIcon2, returnDateLabel, returnDatePicker])
        returnDateStackView.axis = .horizontal
        returnDateStackView.spacing = 8
        returnDateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let oneWayStackView = UIStackView(arrangedSubviews: [oneWayLabel, oneWaySwitch])
        oneWayStackView.axis = .horizontal
        oneWayStackView.spacing = 8
        oneWayStackView.translatesAutoresizingMaskIntoConstraints = false
        
        passengerView.addSubview(personIcon1)
        passengerView.addSubview(passengerLabel)
        passengerView.addSubview(rightArrowIcon1)
        
        NSLayoutConstraint.activate([
            personIcon1.leadingAnchor.constraint(equalTo: passengerView.leadingAnchor, constant: 8),
            personIcon1.centerYAnchor.constraint(equalTo: passengerView.centerYAnchor),
            personIcon1.widthAnchor.constraint(equalToConstant: 30),
            personIcon1.heightAnchor.constraint(equalToConstant: 30),
            
            passengerLabel.centerYAnchor.constraint(equalTo: passengerView.centerYAnchor),
            passengerLabel.leadingAnchor.constraint(equalTo: personIcon1.trailingAnchor, constant: 8),
            
            rightArrowIcon1.trailingAnchor.constraint(equalTo: passengerView.trailingAnchor, constant: -8),
            rightArrowIcon1.centerYAnchor.constraint(equalTo: passengerView.centerYAnchor),
            rightArrowIcon1.widthAnchor.constraint(equalToConstant: 30),
            rightArrowIcon1.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        crewView.addSubview(personIcon2)
        crewView.addSubview(crewLabel)
        crewView.addSubview(rightArrowIcon2)
        
        NSLayoutConstraint.activate([
            personIcon2.leadingAnchor.constraint(equalTo: crewView.leadingAnchor, constant: 8),
            personIcon2.centerYAnchor.constraint(equalTo: crewView.centerYAnchor),
            personIcon2.widthAnchor.constraint(equalToConstant: 30),
            personIcon2.heightAnchor.constraint(equalToConstant: 30),
            
            crewLabel.centerYAnchor.constraint(equalTo: crewView.centerYAnchor),
            crewLabel.leadingAnchor.constraint(equalTo: personIcon2.trailingAnchor, constant: 8),
            
            rightArrowIcon2.trailingAnchor.constraint(equalTo: crewView.trailingAnchor, constant: -8),
            rightArrowIcon2.centerYAnchor.constraint(equalTo: crewView.centerYAnchor),
            rightArrowIcon2.widthAnchor.constraint(equalToConstant: 30),
            rightArrowIcon2.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        let mainStackView = UIStackView(arrangedSubviews: [originStackView, destinationStackView, capacityStackView, departureDateStackView, returnDateStackView, oneWayStackView, passengerView, crewView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackView)
        view.addSubview(takeoffButton)
        
        NSLayoutConstraint.activate([
            originIcon.widthAnchor.constraint(equalToConstant: 30),
            originIcon.heightAnchor.constraint(equalToConstant: 30),
            
            destinationIcon.widthAnchor.constraint(equalToConstant: 30),
            destinationIcon.heightAnchor.constraint(equalToConstant: 30),
            
            peopleIcon.widthAnchor.constraint(equalToConstant: 30),
            peopleIcon.heightAnchor.constraint(equalToConstant: 30),
            
            calendarIcon1.widthAnchor.constraint(equalToConstant: 30),
            calendarIcon1.heightAnchor.constraint(equalToConstant: 30),
            
            calendarIcon2.widthAnchor.constraint(equalToConstant: 30),
            calendarIcon2.heightAnchor.constraint(equalToConstant: 30),
            
            departureDatePicker.heightAnchor.constraint(equalToConstant: 35),
            returnDatePicker.heightAnchor.constraint(equalToConstant: 35),
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            passengerView.heightAnchor.constraint(equalToConstant: 60),
            crewView.heightAnchor.constraint(equalToConstant: 60),
            
            takeoffButton.heightAnchor.constraint(equalToConstant: 50),
            takeoffButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            takeoffButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            takeoffButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
        
    // MARK: - Button Actions
    
    @objc private func stepperValueChanged() {
        capacityLabel.text = "Capacidade de \(Int(stepper.value)) pessoa(s)"
    }
    
    @objc private func takeoffButtonTapped() {
        if validateFlight() {
            let flight = Flight(
                origin: originTextField.text ?? "",
                destination: destinationTextField.text ?? "",
                capacity: Int(stepper.value),
                departureDate: departureDatePicker.date,
                returnDate: oneWaySwitch.isOn ? nil : returnDatePicker.date
            )
            
            FlightManager.shared.addFlight(flight)
            
            let alert = UIAlertController(title: "Sucesso", message: "Voo adicionado com sucesso", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    
    @objc private func passengerViewTapped() {
        let passengerViewController = PassengersViewController()
        passengerViewController.delegate = self
        navigationController?.pushViewController(passengerViewController, animated: true)
    }
    
    @objc private func crewViewTapped() {
        let crewViewController = CrewViewController()
        crewViewController.delegate = self
        navigationController?.pushViewController(crewViewController, animated: true)
    }
    
    // MARK: - Validation
    
    private func validateFlight() -> Bool {
        var errorMessage: String?
        
//        if passengers.isEmpty {
//            errorMessage = "Pelo menos um passageiro deve estar presente."
//        } else if pilots.isEmpty {
//            errorMessage = "É necessário um piloto."
//        } else if coPilots.isEmpty {
//            errorMessage = "É necessário um co-piloto."
//        } else if flightAttendants.count > 3 {
//            errorMessage = "No máximo três comissários"
//        }
//
        if let errorMessage = errorMessage {
            let alert = UIAlertController(title: "Erro", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}

extension NewFlightViewController: PassengersViewControllerDelegate, CrewViewControllerDelegate {
    func didUpdatePassengers(_ passengers: [Passenger]) {
        self.passengers = passengers
        passengerLabel.text = passengers.isEmpty ? "Nenhum passageiro adicionado" : "\(passengers.count) passageiro(s) adicionado(s)"
    }
    
    func didUpdateCrew(pilots: [Pilot], coPilots: [CoPilot], flightAttendants: [FlightAttendant]) {
        self.pilots = pilots
        self.coPilots = coPilots
        self.flightAttendants = flightAttendants
        crewLabel.text = pilots.isEmpty && coPilots.isEmpty && flightAttendants.isEmpty ? "Nenhum tripulante adicionado" : "\(pilots.count + coPilots.count + flightAttendants.count) tripulante(s) adicionado(s)"
    }
}

