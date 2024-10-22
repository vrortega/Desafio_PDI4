///
//  NewFlightViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 17/07/24.
//

import UIKit

class NewFlightViewController: UIViewController {
    
    weak var delegate: CrewViewControllerDelegate?
    var viewModel: NewFlightViewModel?
    
    var onFlightAdded: ((Flight) -> Void)?
    
    var passengers: [Passenger] = []
    var pilots: [Pilot] = []
    var coPilots: [CoPilot] = []
    var flightAttendants: [FlightAttendant] = []
    
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
        return stepper
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
        oneWaySwitch.onTintColor = .systemBlue
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let crewLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum tripulante adicionado"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let takeoffButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Decolar", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Novo Voo"
        
        setupLayout()
        setupGestureRecognizers()
        setupTargets()
        bindViewModel()
    }
    
    private func setupTargets() {
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        takeoffButton.addTarget(self, action: #selector(addFlightButtonTapped), for: .touchUpInside)
    }
    
    private func setupGestureRecognizers() {
        let passengerTapGesture = UITapGestureRecognizer(target: self, action: #selector(passengerViewTapped))
        passengerView.addGestureRecognizer(passengerTapGesture)
        
        let crewTapGesture = UITapGestureRecognizer(target: self, action: #selector(crewViewTapped))
        crewView.addGestureRecognizer(crewTapGesture)
    }
    
    
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            print("viewModel é nil no bindViewModel")
            return
        }

        viewModel.updateCapacityLabel = { [weak self] text in
            self?.capacityLabel.text = text
        }
        
        viewModel.updateOneWayState = { [weak self] isOneWay in
            self?.returnDatePicker.isUserInteractionEnabled = !isOneWay
            self?.returnDatePicker.alpha = isOneWay ? 0.5 : 1.0
        }
        
        viewModel.updatePassengerLabel = { [weak self] text in
            self?.passengerLabel.text = text
        }
        
        viewModel.updateCrewLabel = { [weak self] text in
            self?.crewLabel.text = text
        }
    }
    
    private func setupLayout() {
        let iconSize: CGFloat = 30.0
        let iconSize2: CGFloat = 25.00

        let departureCalendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
        departureCalendarIcon.tintColor = .black
        departureCalendarIcon.translatesAutoresizingMaskIntoConstraints = false

        let returnCalendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
        returnCalendarIcon.tintColor = .black
        returnCalendarIcon.translatesAutoresizingMaskIntoConstraints = false

        let passengerIcon = UIImageView(image: UIImage(systemName: "person.fill"))
        passengerIcon.tintColor = .black
        passengerIcon.translatesAutoresizingMaskIntoConstraints = false

        let capacityIcon = UIImageView(image: UIImage(systemName: "person.3.fill"))
        capacityIcon.tintColor = .black
        capacityIcon.contentMode = .scaleAspectFit
        capacityIcon.translatesAutoresizingMaskIntoConstraints = false

        let crewIcon = UIImageView(image: UIImage(systemName: "person.fill"))
        crewIcon.tintColor = .black
        crewIcon.translatesAutoresizingMaskIntoConstraints = false

        let rightArrowPassenger = UIImageView(image: UIImage(systemName: "arrow.forward.circle.fill"))
        rightArrowPassenger.tintColor = .black
        rightArrowPassenger.translatesAutoresizingMaskIntoConstraints = false

        let rightArrowCrew = UIImageView(image: UIImage(systemName: "arrow.forward.circle.fill"))
        rightArrowCrew.tintColor = .black
        rightArrowCrew.translatesAutoresizingMaskIntoConstraints = false

        let originIcon = UIImageView(image: UIImage(systemName: "airplane.departure"))
        originIcon.tintColor = .black
        originIcon.translatesAutoresizingMaskIntoConstraints = false

        let destinationIcon = UIImageView(image: UIImage(systemName: "airplane.arrival"))
        destinationIcon.tintColor = .black
        destinationIcon.translatesAutoresizingMaskIntoConstraints = false

        let originStackView = UIStackView(arrangedSubviews: [originIcon, originTextField])
        originStackView.axis = .horizontal
        originStackView.alignment = .center
        originStackView.spacing = 8
        originStackView.translatesAutoresizingMaskIntoConstraints = false

        let destinationStackView = UIStackView(arrangedSubviews: [destinationIcon, destinationTextField])
        destinationStackView.axis = .horizontal
        destinationStackView.alignment = .center
        destinationStackView.spacing = 8
        destinationStackView.translatesAutoresizingMaskIntoConstraints = false

        let capacityStackView = UIStackView(arrangedSubviews: [capacityIcon, capacityLabel, stepper])
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
            capacityIcon.widthAnchor.constraint(equalToConstant: iconSize),
            capacityIcon.heightAnchor.constraint(equalToConstant: iconSize),
            departureCalendarIcon.widthAnchor.constraint(equalToConstant: iconSize),
            departureCalendarIcon.heightAnchor.constraint(equalToConstant: iconSize),
            returnCalendarIcon.widthAnchor.constraint(equalToConstant: iconSize),
            returnCalendarIcon.heightAnchor.constraint(equalToConstant: iconSize),
            rightArrowPassenger.widthAnchor.constraint(equalToConstant: iconSize2),
            rightArrowPassenger.heightAnchor.constraint(equalToConstant: iconSize2),
            rightArrowCrew.widthAnchor.constraint(equalToConstant: iconSize2),
            rightArrowCrew.heightAnchor.constraint(equalToConstant: iconSize2),
            
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
            
            passengerView.topAnchor.constraint(equalTo: oneWayStackView.bottomAnchor, constant: 20),
            passengerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passengerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passengerView.heightAnchor.constraint(equalToConstant: 70),
            
            crewView.topAnchor.constraint(equalTo: passengerView.bottomAnchor, constant: 15),
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
            takeoffButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func passengerViewTapped() {
        let passengerVC = PassengersViewController()
        passengerVC.delegate = self
        passengerVC.passengers = self.passengers
        navigationController?.pushViewController(passengerVC, animated: true)
    }
    
    @objc private func crewViewTapped() {
        let crewVC = CrewViewController()
        crewVC.delegate = self
        crewVC.pilots = self.pilots
        crewVC.coPilots = self.coPilots
        crewVC.flightAttendants = self.flightAttendants
        navigationController?.pushViewController(crewVC, animated: true)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        viewModel?.capacity = Int(sender.value)
    }
    
    @objc private func addFlightButtonTapped() {
        guard let viewModel = viewModel else { return }
        
        viewModel.origin = originTextField.text ?? ""
        viewModel.destination = destinationTextField.text ?? ""
        viewModel.departureDate = departureDatePicker.date
        viewModel.returnDate = returnDatePicker.date
        viewModel.isOneWay = oneWaySwitch.isOn
        
        if !viewModel.validateCities() {
            showAlert(title: "Erro", message: "A origem e o destino devem conter 3 caracteres.")
            return
        }
        
        if !viewModel.validateCrew() {
            showAlert(title: "Erro", message: "A tripulação deve conter 1 piloto, 1 copiloto e entre 1 e 3 comissários.")
            return
        }
        
        if !viewModel.validateCapacity() {
            showAlert(title: "Erro", message: "A capacidade deve ser maior ou igual ao total de pessoas a bordo.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let departureDateStr = dateFormatter.string(from: viewModel.departureDate)
        let returnDateStr = viewModel.isOneWay ? nil : dateFormatter.string(from: viewModel.returnDate ?? Date())
        
        let flight = Flight(
            origin: viewModel.origin, destination: viewModel.destination, capacity: viewModel.capacity, departureDate: departureDateStr, returnDate: returnDateStr, pilots: viewModel.pilots, coPilots: viewModel.coPilots, flightAttendants: viewModel.flightAttendants, passengers: viewModel.passengers
        )
        
        onFlightAdded?(flight)
        navigateToFlightsViewController()
    }
    
    private func navigateToFlightsViewController() {
        if let flightsVC = navigationController?.viewControllers.first(where: { $0 is FlightsViewController}) {
            navigationController?.popToViewController(flightsVC, animated: true)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension NewFlightViewController: PassengersViewControllerDelegate {
    func didAddPassengers(_ passengers: [Passenger]) {
        self.passengers = passengers
        viewModel?.passengers = passengers
        updatePassengerLabel()
    }
    
    private func updatePassengerLabel() {
        if passengers.isEmpty {
            passengerLabel.text = "Nenhum passageiro adicionado"
        } else {
            passengerLabel.text = "\(passengers.count) passageiro(s) adicionado(s)"
        }
    }
}

extension NewFlightViewController: CrewViewControllerDelegate {
    func didAddCrew(pilots: [Pilot], coPilots: [CoPilot], flightAttendants: [FlightAttendant]) {
        self.pilots = pilots
        self.coPilots = coPilots
        self.flightAttendants = flightAttendants
        
        viewModel?.pilots = pilots
        viewModel?.coPilots = coPilots
        viewModel?.flightAttendants = flightAttendants
        updateCrewLabel()
    }
    
    private func updateCrewLabel() {
        let totalCrew = pilots.count + coPilots.count + flightAttendants.count
        if totalCrew == 0 {
            crewLabel.text = "Nenhum tripulante adicionado"
        } else {
            crewLabel.text = "\(totalCrew) tripulante(s) adicionado(s)"
        }
    }
}
