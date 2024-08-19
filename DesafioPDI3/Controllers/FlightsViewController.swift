//
//  FlightsViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 17/07/24.
//

import Foundation
import UIKit
import CoreLocation

class FlightsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    private let tableView = UITableView()
    private let weatherView = UIView()
    private let locationLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let windLabel = UILabel()
    private let humidityLabel = UILabel()
    private let locationManager = CLLocationManager()

    private let noFlightsLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum voo adicionado"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let viewModel = FlightsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Voos"
        
        setupViews()
        configureViews()
        
        setupViewModelBindings() 
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "flightCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateNoFlightsLabel()
    }

    private func setupViews() {
        setupNavigationBar()
        setupWeatherView()
        updateNoFlightsLabel()
    }

    private func configureViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFlightTapped))
    }

    private func setupWeatherView() {
        weatherView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        weatherView.layer.cornerRadius = 10
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let temperatureIcon = UIImageView(image: UIImage(systemName: "thermometer"))
        temperatureIcon.translatesAutoresizingMaskIntoConstraints = false
        temperatureIcon.contentMode = .scaleAspectFit
        let temperatureStackView = createStackView(with: temperatureIcon, label: temperatureLabel)
        
        let windIcon = UIImageView(image: UIImage(systemName: "wind"))
        windIcon.translatesAutoresizingMaskIntoConstraints = false
        windIcon.contentMode = .scaleAspectFit
        let windStackView = createStackView(with: windIcon, label: windLabel)
        
        let humidityIcon = UIImageView(image: UIImage(systemName: "drop"))
        humidityIcon.translatesAutoresizingMaskIntoConstraints = false
        humidityIcon.contentMode = .scaleAspectFit
        let humidityStackView = createStackView(with: humidityIcon, label: humidityLabel)
        
        let infoStackView = UIStackView(arrangedSubviews: [temperatureStackView, windStackView, humidityStackView])
        infoStackView.axis = .horizontal
        infoStackView.alignment = .center
        infoStackView.distribution = .equalSpacing
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        weatherView.addSubview(locationLabel)
        weatherView.addSubview(infoStackView)
        view.addSubview(weatherView)
        
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherView.heightAnchor.constraint(equalToConstant: 120),
            
            locationLabel.topAnchor.constraint(equalTo: weatherView.topAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 16),
            
            infoStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor, constant: -16),
        ])
    }

    private func createStackView(with icon: UIImageView, label: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [icon, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func updateNoFlightsLabel() {
        noFlightsLabel.isHidden = !viewModel.flights.isEmpty
        tableView.isHidden = viewModel.flights.isEmpty

        if viewModel.flights.isEmpty {
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
        newFlightVC.viewModel = NewFlightViewModel()
        configureOnFlightAddedCallback(for: newFlightVC)
        navigationController?.pushViewController(newFlightVC, animated: true)
    }

    private func configureOnFlightAddedCallback(for newFlightVC: NewFlightViewController) {
        newFlightVC.onFlightAdded = { [weak self] flight in
            self?.viewModel.addFlight(flight)
            self?.viewModel.updateFlightList?()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.flights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createFlightCell(for: indexPath)
    }

    private func createFlightCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flightCell", for: indexPath)
        let flight = viewModel.flights[indexPath.row]
        cell.textLabel?.text = "\(flight.origin) - \(flight.destination)"
        cell.detailTextLabel?.text = flightDetailText(for: flight)
        return cell
    }

    private func flightDetailText(for flight: Flight) -> String {
        let parseFormatter = DateFormatter()
        parseFormatter.dateFormat = "yyyy-MM-dd"

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium

        var departureDateString = "Data inválida"
        if let departureDate = parseFormatter.date(from: flight.departureDate) {
            departureDateString = displayFormatter.string(from: departureDate)
        }

        var returnDateString: String?
        if let returnDateStr = flight.returnDate, !returnDateStr.isEmpty, let returnDate = parseFormatter.date(from: returnDateStr) {
            returnDateString = displayFormatter.string(from: returnDate)
        }

        if let returnDateString = returnDateString {
            return "Ida: \(departureDateString) - Volta: \(returnDateString) | \(flight.passengers.count) passageiro(s)"
        } else {
            return "Ida: \(departureDateString) - Somente ida | \(flight.passengers.count) passageiro(s)"
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFlight(at: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFlight = viewModel.flights[indexPath.row]
        let flightDetailsVC = FlightDetailsViewController()
        flightDetailsVC.flight = selectedFlight
        
        navigationController?.pushViewController(flightDetailsVC, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task {
            await viewModel.fetchWeather(for: location.coordinate)
            
            DispatchQueue.main.async {
                self.updateWeatherView()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
        weatherView.isHidden = true
    }
    
    private func setupViewModelBindings() {
        viewModel.updateFlightList = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateNoFlightsLabel()
            }
        }

        viewModel.updateWeatherView = { [weak self] in
            DispatchQueue.main.async {
                self?.updateWeatherView()
            }
        }

        viewModel.updateNoFlightsLabelVisibility = { [weak self] isVisible in
            DispatchQueue.main.async {
                self?.noFlightsLabel.isHidden = !isVisible
                self?.tableView.isHidden = !isVisible
            }
        }
    }
    
    private func updateWeatherView() {
        locationLabel.text = viewModel.location
        temperatureLabel.text = viewModel.temperature
        windLabel.text = viewModel.windSpeed
        humidityLabel.text = viewModel.humidity
    }
}
