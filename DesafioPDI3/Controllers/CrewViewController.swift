//
//  CrewViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 18/07/24.
//

import UIKit

protocol CrewViewControllerDelegate: AnyObject {
    func didAddCrew(pilots: [Pilot], coPilots: [CoPilot], flightAttendants: [FlightAttendant])
}

class CrewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: CrewViewControllerDelegate?
    
    private let roleSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Piloto", "Comissário"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(roleSegmentChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nome"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let experienceLabel: UILabel = {
        let label = UILabel()
        label.text = "Experiência: 1 ano(s)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let experienceStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 50
        stepper.value = 1
        stepper.stepValue = 1
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
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
    
    private let noCrewLabel: UILabel = {
        let label = UILabel()
        label.text = "Ainda não há tripulantes"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let crewTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var pilots: [Pilot] = []
    var coPilots: [CoPilot] = []
    var flightAttendants: [FlightAttendant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Tripulantes"
        
        crewTableView.dataSource = self
        crewTableView.delegate = self
        crewTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CrewCell")
        
        setupLayout()
        updateUI(for: roleSegmentedControl.selectedSegmentIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCrewTable()
    }
    
    private func setupLayout() {
        let experienceStackView = UIStackView(arrangedSubviews: [experienceLabel, experienceStepper])
        experienceStackView.axis = .horizontal
        experienceStackView.spacing = 8
        experienceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(roleSegmentedControl)
        view.addSubview(nameTextField)
        view.addSubview(experienceStackView)
        view.addSubview(embarkButton)
        view.addSubview(noCrewLabel)
        view.addSubview(crewTableView)

        NSLayoutConstraint.activate([
            roleSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            roleSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            roleSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            roleSegmentedControl.heightAnchor.constraint(equalToConstant: 35),
            
            nameTextField.topAnchor.constraint(equalTo: roleSegmentedControl.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: roleSegmentedControl.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: roleSegmentedControl.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 35),
            
            experienceStackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            experienceStackView.leadingAnchor.constraint(equalTo: roleSegmentedControl.leadingAnchor),
            experienceStackView.trailingAnchor.constraint(equalTo: roleSegmentedControl.trailingAnchor),
            
            embarkButton.topAnchor.constraint(equalTo: experienceStackView.bottomAnchor, constant: 16),
            embarkButton.leadingAnchor.constraint(equalTo: roleSegmentedControl.leadingAnchor),
            embarkButton.trailingAnchor.constraint(equalTo: roleSegmentedControl.trailingAnchor),
            embarkButton.heightAnchor.constraint(equalToConstant: 44),
            
            noCrewLabel.topAnchor.constraint(equalTo: embarkButton.bottomAnchor, constant: 16),
            noCrewLabel.leadingAnchor.constraint(equalTo: roleSegmentedControl.leadingAnchor),
            noCrewLabel.trailingAnchor.constraint(equalTo: roleSegmentedControl.trailingAnchor),
            
            crewTableView.topAnchor.constraint(equalTo: embarkButton.bottomAnchor, constant: 15),
            crewTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            crewTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            crewTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    @objc private func stepperValueChanged() {
        experienceLabel.text = "Experiência: \(Int(experienceStepper.value)) ano(s)"
    }
    
    @objc private func roleSegmentChanged() {
        updateUI(for: roleSegmentedControl.selectedSegmentIndex)
    }
    
    private func updateUI(for selectedIndex: Int) {
        let isPilotSelected = selectedIndex == 0
        experienceLabel.isEnabled = isPilotSelected
        experienceStepper.isEnabled = isPilotSelected
        
        if isPilotSelected {
            experienceLabel.text = "Experiência: \(Int(experienceStepper.value)) ano(s)"
        } else {
            experienceLabel.text = "Experiência mínima nao requerida"
        }
    }
    
    @objc private func embarkButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            let alert = UIAlertController(title: "Erro", message: "Por favor, insira um nome válido.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let experience = Int(experienceStepper.value)
        
        if roleSegmentedControl.selectedSegmentIndex == 0 {
            if experience >= 5 {
                let newPilot = Pilot(name: name, experience: experience)
                pilots.append(newPilot)
            } else {
                let newCoPilot = CoPilot(name: name, experience: experience)
                coPilots.append(newCoPilot)
            }
        } else {
            let newFlightAttendant = FlightAttendant(name: name)
            flightAttendants.append(newFlightAttendant)
        }
        
        nameTextField.text = ""
        experienceStepper.value = 0
        stepperValueChanged()
        
        updateUI(for: roleSegmentedControl.selectedSegmentIndex)
        
        updateCrewTable()
        crewTableView.reloadData()
        
        delegate?.didAddCrew(pilots: pilots, coPilots: coPilots, flightAttendants: flightAttendants)
    }
    
    private func updateCrewTable() {
        let hasCrew = !pilots.isEmpty || !coPilots.isEmpty || !flightAttendants.isEmpty
        noCrewLabel.isHidden = hasCrew
        crewTableView.isHidden = !hasCrew
        crewTableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pilots.count + coPilots.count + flightAttendants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CrewCell", for: indexPath)
        
        if indexPath.row < pilots.count {
            let pilot = pilots[indexPath.row]
            cell.textLabel?.text = "Piloto: \(pilot.name), Experiência: \(pilot.experience) ano(s)"
        } else if indexPath.row < pilots.count + coPilots.count {
            let coPilot = coPilots[indexPath.row - pilots.count]
            cell.textLabel?.text = "Co-Piloto: \(coPilot.name), Experiência: \(coPilot.experience) ano(s)"
        } else {
            let flightAttendant = flightAttendants[indexPath.row - pilots.count - coPilots.count]
            cell.textLabel?.text = "Comissário: \(flightAttendant.name)"
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row < pilots.count {
                pilots.remove(at: indexPath.row)
            } else if indexPath.row < pilots.count + coPilots.count {
                coPilots.remove(at: indexPath.row - pilots.count)
            } else {
                flightAttendants.remove(at: indexPath.row - pilots.count - coPilots.count)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateCrewTable()
        }
    }
}
