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

    private let viewModel = CrewViewModel()

    weak var delegate: CrewViewControllerDelegate?
    
    var pilots: [Pilot] = []
    var coPilots: [CoPilot] = []
    var flightAttendants: [FlightAttendant] = []

    private let roleSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Piloto", "Comissário"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
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
        return stepper
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Tripulantes"

        crewTableView.dataSource = self
        crewTableView.delegate = self
        crewTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CrewCell")

        setupLayout()
        setupActions()
        bindViewModel()
        
        viewModel.pilots = pilots
        viewModel.coPilots = coPilots
        viewModel.flightAttendants = flightAttendants

        viewModel.updateUI(for: roleSegmentedControl.selectedSegmentIndex)
        viewModel.onCrewUpdated?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        crewTableView.reloadData()
    }

    // MARK: - Layout
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
            crewTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            crewTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            crewTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Actions
    private func setupActions() {
        roleSegmentedControl.addTarget(self, action: #selector(roleSegmentChanged), for: .valueChanged)
        experienceStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        embarkButton.addTarget(self, action: #selector(embarkButtonTapped), for: .touchUpInside)
    }

    @objc private func roleSegmentChanged() {
        viewModel.updateUI(for: roleSegmentedControl.selectedSegmentIndex)
    }

    @objc private func stepperValueChanged() {
        viewModel.updateExperienceLabel(value: experienceStepper.value)
    }

    @objc private func embarkButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Por favor, insira um nome válido.")
            return
        }

        viewModel.addCrewMember(name: name, experience: Int(experienceStepper.value), role: roleSegmentedControl.selectedSegmentIndex)

        clearFields()
        delegate?.didAddCrew(pilots: viewModel.pilots, coPilots: viewModel.coPilots, flightAttendants: viewModel.flightAttendants)
    }

    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onExperienceLabelUpdate = { [weak self] updatedText in
            self?.experienceLabel.text = updatedText
        }

        viewModel.onCrewUpdated = { [weak self] in
            self?.crewTableView.reloadData()
            self?.noCrewLabel.isHidden = self?.viewModel.hasCrew() ?? false
            self?.crewTableView.isHidden = !(self?.viewModel.hasCrew() ?? false)
        }
    }

    // MARK: - Helper Methods
    private func clearFields() {
        nameTextField.text = ""
        experienceStepper.value = 1
        stepperValueChanged()
        viewModel.updateUI(for: roleSegmentedControl.selectedSegmentIndex)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource and UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.crewCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CrewCell", for: indexPath)
        cell.textLabel?.text = viewModel.crewMember(at: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteCrewMember(at: indexPath.row)
        }
    }
}

