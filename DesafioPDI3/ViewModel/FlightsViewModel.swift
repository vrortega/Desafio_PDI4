//
//  FlightsViewModel.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 16/10/24.
//

import Foundation
import CoreLocation

class FlightsViewModel {

    var flights: [Flight] = [] {
        didSet {
            updateFlightList?()
            updateNoFlightsLabelVisibility?(!flights.isEmpty)
        }
    }

    var updateFlightList: (() -> Void)?
    var updateNoFlightsLabelVisibility: ((Bool) -> Void)?
    
    var location: String = "" {
        didSet {
            updateWeatherView?()
        }
    }
    
    var temperature: String = "" {
        didSet {
            updateWeatherView?()
        }
    }
    
    var windSpeed: String = "" {
        didSet {
            updateWeatherView?()
        }
    }
    
    var humidity: String = "" {
        didSet {
            updateWeatherView?()
        }
    }
    
    var updateWeatherView: (() -> Void)?

    func addFlight(_ flight: Flight) {
        flights.append(flight)
    }

    func removeFlight(at index: Int) {
        flights.remove(at: index)
    }

    func fetchWeather(for coordinate: CLLocationCoordinate2D) async {
        let apiKey = "ce0b023afe564606bb6232253243007"
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(coordinate.latitude),\(coordinate.longitude)"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            updateWeather(with: weatherResponse)
        } catch {
            print("Failed to fetch weather data: \(error)")
        }
    }

    private func updateWeather(with weatherResponse: WeatherResponse) {
        location = "\(weatherResponse.location.name), \(weatherResponse.location.region)"
        temperature = "\(weatherResponse.current.temp_c)°C"
        windSpeed = "\(weatherResponse.current.wind_kph) kph"
        humidity = "\(weatherResponse.current.humidity)%"
    }
}
