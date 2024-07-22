//
//  CrewViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 18/07/24.
//

import UIKit

class CrewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        button.backgroundColor = .systemGreen
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
    
    private var pilots: [Pilot] = []
    private var coPilots: [CoPilot] = []
    private var flightAttendants: [FlightAttendant] = []

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
    
    private func setupLayout() {
        let experienceStackView = UIStackView(arrangedSubviews: [experienceLabel, experienceStepper])
        experienceStackView.axis = .horizontal
        experienceStackView.spacing = 8
        experienceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [roleSegmentedControl, nameTextField, experienceStackView, embarkButton, noCrewLabel, crewTableView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            roleSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            embarkButton.heightAnchor.constraint(equalToConstant: 44),
            crewTableView.heightAnchor.constraint(equalToConstant: 200)
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
            if experience > 5 {
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
        experienceStepper.value = 1
        stepperValueChanged()
        
        updateUI(for: roleSegmentedControl.selectedSegmentIndex)
        updateCrewTable()
    }
    
    private func updateCrewTable() {
        let hasCrew = !pilots.isEmpty || !coPilots.isEmpty || !flightAttendants.isEmpty
        noCrewLabel.isHidden = hasCrew
        crewTableView.isHidden = !hasCrew
        crewTableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
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
    
    // MARK: - UITableViewDelegate
    
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
