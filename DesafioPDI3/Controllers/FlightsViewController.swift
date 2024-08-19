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
    
    private var flights: [Flight] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Voos"
        
        setupNavigationBar()
        setupWeatherView()
        setupTableView()
        updateNoFlightsLabel()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        print("FlightsViewController - viewDidLoad: \(flights.count) voos")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateNoFlightsLabel()
        
        print("FlightsViewController - viewWillAppear: \(flights.count) voos")
        
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
        let temperatureStackView = UIStackView(arrangedSubviews: [temperatureIcon, temperatureLabel])
        temperatureStackView.axis = .vertical
        temperatureStackView.alignment = .center
        temperatureStackView.spacing = 4
        temperatureStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let windIcon = UIImageView(image: UIImage(systemName: "wind"))
        windIcon.translatesAutoresizingMaskIntoConstraints = false
        windIcon.contentMode = .scaleAspectFit
        let windStackView = UIStackView(arrangedSubviews: [windIcon, windLabel])
        windStackView.axis = .vertical
        windStackView.alignment = .center
        windStackView.spacing = 4
        windStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let humidityIcon = UIImageView(image: UIImage(systemName: "drop"))
        humidityIcon.translatesAutoresizingMaskIntoConstraints = false
        humidityIcon.contentMode = .scaleAspectFit
        let humidityStackView = UIStackView(arrangedSubviews: [humidityIcon, humidityLabel])
        humidityStackView.axis = .vertical
        humidityStackView.alignment = .center
        humidityStackView.spacing = 4
        humidityStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    private func setupTableView() {
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
    
    private func updateNoFlightsLabel() {
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
        newFlightVC.onFlightAdded = { [weak self] flight in
            self?.flights.append(flight)
            self?.tableView.reloadData()
            self?.updateNoFlightsLabel()
            
        }
        
        navigationController?.pushViewController(newFlightVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flightCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "flightCell")
        
        let flight = flights[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var departureDateString = "Data inválida"
        if let departureDate = dateFormatter.date(from: flight.departureDate) {
            dateFormatter.dateStyle = .medium
            departureDateString = dateFormatter.string(from: departureDate)
        }
                var returnDateString: String? = nil
        if let returnDateStr = flight.returnDate, let returnDate = dateFormatter.date(from: returnDateStr) {
            returnDateString = dateFormatter.string(from: returnDate)
        }
        
        var detailText: String
        if let returnDateString = returnDateString {
            detailText = "Ida: \(departureDateString) - Volta: \(returnDateString) | \(flight.passengers.count) passageiro(s)"
        } else {
            detailText = "Ida: \(departureDateString) - Somente ida | \(flight.passengers.count) passageiro(s)"
        }
        
        cell.textLabel?.text = "\(flight.origin) - \(flight.destination)"
        cell.detailTextLabel?.text = detailText
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            flights.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            updateNoFlightsLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFlight = flights[indexPath.row]
        let flightDetailsVC = FlightDetailsViewController()
        flightDetailsVC.flight = selectedFlight
        
        navigationController?.pushViewController(flightDetailsVC, animated: true)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task {
            await fetchWeather(for: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
    
    private func fetchWeather(for coordinate: CLLocationCoordinate2D) async {
        let apiKey = "ce0b023afe564606bb6232253243007"
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(coordinate.latitude),\(coordinate.longitude)"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            updateWeatherView(with: weatherResponse)
        } catch {
            print("Failed to fetch weather data: \(error)")
        }
    }
    
    private func updateWeatherView(with weatherResponse: WeatherResponse) {
        locationLabel.text = "\(weatherResponse.location.name), \(weatherResponse.location.region)"
        temperatureLabel.text = "\(weatherResponse.current.temp_c)°C"
        windLabel.text = "\(weatherResponse.current.wind_kph) kph"
        humidityLabel.text = "\(weatherResponse.current.humidity)%"
    }
}
