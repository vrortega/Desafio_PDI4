//
//  FlightsViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 17/07/24.
//

import Foundation
import UIKit

class FlightsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let noFlightsLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum voo adicionado"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Voos"
        
        setupNavigationBar()
        setupTableView()
        updateNoFlightsLabel()
        
        print("FlightsViewController - viewDidLoad: \(FlightManager.shared.flights.count) voos")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateNoFlightsLabel()
        
        print("FlightsViewController - viewWillAppear: \(FlightManager.shared.flights.count) voos")
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFlightTapped))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateNoFlightsLabel() {
        let flights = FlightManager.shared.flights
        noFlightsLabel.isHidden = !flights.isEmpty
        tableView.isHidden = flights.isEmpty
        
        if flights.isEmpty {
            view.addSubview(noFlightsLabel)
            NSLayoutConstraint.activate([
                noFlightsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                noFlightsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        } else {
            noFlightsLabel.removeFromSuperview()
        }
    }
    
    @objc private func addFlightTapped() {
        let newFlightVC = NewFlightViewController()
        navigationController?.pushViewController(newFlightVC, animated: true)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = FlightManager.shared.flights.count
        print("numberOfRowsInSection: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flightCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "flightCell")
        let flight = FlightManager.shared.flights[indexPath.row]
        cell.textLabel?.text = "\(flight.origin) -> \(flight.destination)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        cell.detailTextLabel?.text = "Ida: \(dateFormatter.string(from: flight.departureDate))" + (flight.returnDate != nil ? ", Volta: \(dateFormatter.string(from: flight.returnDate!))" : "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FlightManager.shared.removeFlight(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateNoFlightsLabel()
        }
    }
}
