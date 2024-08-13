///
//  NewFlightViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 17/07/24.
//

import UIKit

class NewFlightViewController: UIViewController {
    
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
    
    private let rightArrowIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let takeoffButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Decolar", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addFlightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var passengers: [Passenger] = []
    var pilots: [Pilot] = []
    var coPilots: [CoPilot] = []
    var flightAttendants: [FlightAttendant] = []
    
  var onFlightAdded: ((Flight) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Novo Voo"
        
        setupGestureRecognizers()
        setupLayout()
        
        oneWaySwitch.addTarget(self, action: #selector(oneWaySwitchChanged), for: .valueChanged)
    }
    
    
    private func setupGestureRecognizers() {
        let passengerTapGesture = UITapGestureRecognizer(target: self, action: #selector(passengerViewTapped))
        passengerView.addGestureRecognizer(passengerTapGesture)
        
        let crewTapGesture = UITapGestureRecognizer(target: self, action: #selector(crewViewTapped))
        crewView.addGestureRecognizer(crewTapGesture)
    }
    
    private func setupLayout() {
        let iconSize: CGFloat = 30.0
        
        let departureCalendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
        departureCalendarIcon.tintColor = .black
        departureCalendarIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let returnCalendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
        returnCalendarIcon.tintColor = .black
        returnCalendarIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let passengerIcon = UIImageView(image: UIImage(systemName: "person.fill"))
        passengerIcon.tintColor = .black
        passengerIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let crewIcon = UIImageView(image: UIImage(systemName: "person.fill"))
        crewIcon.tintColor = .black
        crewIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let rightArrowPassenger = UIImageView(image: UIImage(systemName: "chevron.right"))
        rightArrowPassenger.tintColor = .black
        rightArrowPassenger.translatesAutoresizingMaskIntoConstraints = false
        
        let rightArrowCrew = UIImageView(image: UIImage(systemName: "chevron.right"))
        rightArrowCrew.tintColor = .black
        rightArrowCrew.translatesAutoresizingMaskIntoConstraints = false
        
        let originStackView = UIStackView(arrangedSubviews: [originIcon, originTextField])
        originStackView.axis = .horizontal
        originStackView.spacing = 8
        originStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let destinationStackView = UIStackView(arrangedSubviews: [destinationIcon, destinationTextField])
        destinationStackView.axis = .horizontal
        destinationStackView.spacing = 8
        destinationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let capacityStackView = UIStackView(arrangedSubviews: [passengerIcon, capacityLabel, stepper])
        capacityStackView.axis = .horizontal
        capacityStackView.spacing = 8
        capacityStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let departureDateStackView = UIStackView(arrangedSubviews: [departureCalendarIcon, departureDateLabel, departureDatePicker])
        departureDateStackView.axis = .horizontal
        departureDateStackView.spacing = 8
        departureDateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let returnDateStackView = UIStackView(arrangedSubviews: [returnCalendarIcon, returnDateLabel, returnDatePicker])
        returnDateStackView.axis = .horizontal
        returnDateStackView.spacing = 8
        returnDateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let oneWayStackView = UIStackView(arrangedSubviews: [oneWayLabel, oneWaySwitch])
        oneWayStackView.axis = .horizontal
        oneWayStackView.spacing = 8
        oneWayStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let passengerStackView = UIStackView(arrangedSubviews: [passengerIcon, passengerLabel, rightArrowPassenger])
        passengerStackView.axis = .horizontal
        passengerStackView.spacing = 10
        passengerStackView.alignment = .center
        passengerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let crewStackView = UIStackView(arrangedSubviews: [crewIcon, crewLabel, rightArrowCrew])
        crewStackView.axis = .horizontal
        crewStackView.spacing = 8
        crewStackView.alignment = .center
        crewStackView.translatesAutoresizingMaskIntoConstraints = false
        
        passengerView.addSubview(passengerStackView)
        crewView.addSubview(crewStackView)
        
        view.addSubview(originStackView)
        view.addSubview(destinationStackView)
        view.addSubview(capacityStackView)
        view.addSubview(departureDateStackView)
        view.addSubview(returnDateStackView)
        view.addSubview(oneWayStackView)
        view.addSubview(passengerView)
        view.addSubview(crewView)
        view.addSubview(takeoffButton)
        
        NSLayoutConstraint.activate([
            originIcon.widthAnchor.constraint(equalToConstant: iconSize),
            originIcon.heightAnchor.constraint(equalToConstant: iconSize),
            destinationIcon.widthAnchor.constraint(equalToConstant: iconSize),
            destinationIcon.heightAnchor.constraint(equalToConstant: iconSize),
            passengerIcon.widthAnchor.constraint(equalToConstant: iconSize),
            passengerIcon.heightAnchor.constraint(equalToConstant: iconSize),
            crewIcon.widthAnchor.constraint(equalToConstant: iconSize),
            crewIcon.heightAnchor.constraint(equalToConstant: iconSize),
            departureCalendarIcon.widthAnchor.constraint(equalToConstant: iconSize),
            departureCalendarIcon.heightAnchor.constraint(equalToConstant: iconSize),
            returnCalendarIcon.widthAnchor.constraint(equalToConstant: iconSize),
            returnCalendarIcon.heightAnchor.constraint(equalToConstant: iconSize),
            rightArrowPassenger.widthAnchor.constraint(equalToConstant: iconSize),
            rightArrowPassenger.heightAnchor.constraint(equalToConstant: iconSize),
            rightArrowCrew.widthAnchor.constraint(equalToConstant: iconSize),
            rightArrowCrew.heightAnchor.constraint(equalToConstant: iconSize),
            
            originStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            originStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            originStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            destinationStackView.topAnchor.constraint(equalTo: originStackView.bottomAnchor, constant: 16),
            destinationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            destinationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            capacityStackView.topAnchor.constraint(equalTo: destinationStackView.bottomAnchor, constant: 16),
            capacityStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            capacityStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            departureDateStackView.topAnchor.constraint(equalTo: capacityStackView.bottomAnchor, constant: 20),
            departureDateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            departureDateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            returnDateStackView.topAnchor.constraint(equalTo: departureDateStackView.bottomAnchor, constant: 20),
            returnDateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnDateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            originTextField.heightAnchor.constraint(equalToConstant: 40),
            destinationTextField.heightAnchor.constraint(equalToConstant: 40),
            
            oneWayStackView.topAnchor.constraint(equalTo: returnDateStackView.bottomAnchor, constant: 16),
            oneWayStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            oneWayStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            passengerView.topAnchor.constraint(equalTo: oneWayStackView.bottomAnchor, constant: 32),
            passengerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passengerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passengerView.heightAnchor.constraint(equalToConstant: 70),
            
            crewView.topAnchor.constraint(equalTo: passengerView.bottomAnchor, constant: 30),
            crewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            crewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            crewView.heightAnchor.constraint(equalToConstant: 70),
            
            passengerStackView.centerYAnchor.constraint(equalTo: passengerView.centerYAnchor),
            passengerStackView.leadingAnchor.constraint(equalTo: passengerView.leadingAnchor, constant: 8),
            passengerStackView.trailingAnchor.constraint(equalTo: passengerView.trailingAnchor, constant: -8),
            
            crewStackView.centerYAnchor.constraint(equalTo: crewView.centerYAnchor),
            crewStackView.leadingAnchor.constraint(equalTo: crewView.leadingAnchor, constant: 8),
            crewStackView.trailingAnchor.constraint(equalTo: crewView.trailingAnchor, constant: -8),
            
            takeoffButton.topAnchor.constraint(equalTo: crewView.bottomAnchor, constant: 60),
            takeoffButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            takeoffButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            takeoffButton.heightAnchor.constraint(equalToConstant: 50)

        ])
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        let capacity = Int(sender.value)
        capacityLabel.text = "Capacidade de \(capacity) pessoa(s)"
    }
    
    @objc private func oneWaySwitchChanged(_ sender: UISwitch) {
        returnDateLabel.isHidden = sender.isOn
        returnDatePicker.isHidden = sender.isOn
    }
    
    @objc private func passengerViewTapped() {
        let passengersVC = PassengersViewController()
        passengersVC.passengers = passengers
        passengersVC.delegate = self
        navigationController?.pushViewController(passengersVC, animated: true)
    }
    
    @objc private func crewViewTapped() {
        let crewVC = CrewViewController()
        crewVC.pilots = pilots
        crewVC.coPilots = coPilots
        crewVC.flightAttendants = flightAttendants
        navigationController?.pushViewController(crewVC, animated: true)
    }
    
    @objc private func addFlightButtonTapped() {
         guard let origin = originTextField.text, !origin.isEmpty,
               let destination = destinationTextField.text, !destination.isEmpty else {
             let alert = UIAlertController(title: "Erro", message: "Por favor, preencha todos os campos.", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default))
             present(alert, animated: true)
             return
         }
         
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let departureDate = dateFormatter.string(from: departureDatePicker.date)
         let returnDate = dateFormatter.string(from: returnDatePicker.date)
         
         let capacity = Int(stepper.value)
         let flight = Flight(origin: origin, destination: destination, capacity: capacity, departureDate: departureDate, returnDate: returnDate, pilots: [], coPilots: [], flightAttendants: [], passengers: [])
         
        onFlightAdded?(flight)
        navigationController?.popViewController(animated: true)
     }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension NewFlightViewController: PassengersViewControllerDelegate {
    func didUpdatePassengers(_ passengers: [Passenger]) {
        self.passengers = passengers
        updatePassengerLabel()
    }

    private func updatePassengerLabel() {
        if passengers.isEmpty {
            passengerLabel.text = "Nenhum passageiro adicionado"
        } else {
            passengerLabel.text = "\(passengers.count) passageiro(s) adicionados"
        }
    }
}
