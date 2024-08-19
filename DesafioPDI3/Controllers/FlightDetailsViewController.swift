//
//  FlightDetailsViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 07/08/24.
//

import UIKit

class FlightDetailsViewController: UIViewController {
    var flight: Flight?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let flightInfoView = UIView()
    private let passengersView = UIView()
    private let crewView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Detalhes do Voo"

        setupViews()
        setupConstraints()
        configureViews()
    }

    private func setupViews() {
        let gray200 = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)

        flightInfoView.backgroundColor = gray200
        flightInfoView.layer.cornerRadius = 10

        passengersView.backgroundColor = gray200
        passengersView.layer.cornerRadius = 10

        crewView.backgroundColor = gray200
        crewView.layer.cornerRadius = 10

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        flightInfoView.translatesAutoresizingMaskIntoConstraints = false
        passengersView.translatesAutoresizingMaskIntoConstraints = false
        crewView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(flightInfoView)
        contentView.addSubview(passengersView)
        contentView.addSubview(crewView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            flightInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            flightInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            flightInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            passengersView.topAnchor.constraint(equalTo: flightInfoView.bottomAnchor, constant: 20),
            passengersView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passengersView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            crewView.topAnchor.constraint(equalTo: passengersView.bottomAnchor, constant: 20),
            crewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            crewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            crewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func configureViews() {
        guard let flight = flight else { return }

        let originLabel = UILabel()
        originLabel.text = flight.origin
        originLabel.font = .systemFont(ofSize: 70, weight: .bold)

        let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.left.arrow.right"))
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true

        let destinationLabel = UILabel()
        destinationLabel.text = flight.destination
        destinationLabel.font = .systemFont(ofSize: 70, weight: .bold)

        let originDestinationStackView = UIStackView(arrangedSubviews: [originLabel, arrowImageView, destinationLabel])
        originDestinationStackView.axis = .horizontal
        originDestinationStackView.alignment = .center
        originDestinationStackView.spacing = 4
        originDestinationStackView.distribution = .equalSpacing

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"

        let departureDate = dateFormatter.date(from: flight.departureDate) ?? Date()
        let formattedDepartureDate = dateFormatter.string(from: departureDate)
        let departureDateLabel = UILabel()
        departureDateLabel.text = "Ida: \(formattedDepartureDate)"
        departureDateLabel.font = .systemFont(ofSize: 14, weight: .regular)


        let returnDateText = flight.returnDate != nil ? flight.returnDate : ""
        let returnDate = dateFormatter.date(from: returnDateText ?? "") ?? Date()
        let formattedReturnDate = dateFormatter.string(from: returnDate)
        let returnDateLabel = UILabel()
        returnDateLabel.text = returnDateText != "" ? "Volta: \(formattedReturnDate)" : ""
        returnDateLabel.font = .systemFont(ofSize: 14, weight: .regular)

        let datesStackView = UIStackView(arrangedSubviews: [departureDateLabel, returnDateLabel])
        datesStackView.axis = .vertical
        datesStackView.alignment = .center
        datesStackView.spacing = 8
        
        flightInfoView.addSubview(datesStackView)

        let flightInfoStackView = UIStackView(arrangedSubviews: [originDestinationStackView, datesStackView])
        flightInfoStackView.axis = .vertical
        flightInfoStackView.spacing = 16
        flightInfoStackView.translatesAutoresizingMaskIntoConstraints = false

        flightInfoView.addSubview(flightInfoStackView)

        NSLayoutConstraint.activate([
            flightInfoStackView.topAnchor.constraint(equalTo: flightInfoView.topAnchor, constant: 20),
            flightInfoStackView.leadingAnchor.constraint(equalTo: flightInfoView.leadingAnchor, constant: 20),
            flightInfoStackView.trailingAnchor.constraint(equalTo: flightInfoView.trailingAnchor, constant: -20),
            flightInfoStackView.bottomAnchor.constraint(equalTo: flightInfoView.bottomAnchor, constant: -20)
        ])

        let passengersLabel = UILabel()
        passengersLabel.text = "Passageiros | Capacidade: \(flight.capacity)"
        passengersLabel.font = .systemFont(ofSize: 18, weight: .bold)

        let passengersStackView = UIStackView(arrangedSubviews: [passengersLabel])
        passengersStackView.axis = .vertical
        passengersStackView.spacing = 8
        passengersStackView.translatesAutoresizingMaskIntoConstraints = false

        for passenger in flight.passengers {
            let passengerLabel = UILabel()
            passengerLabel.text = passenger.name
            passengersStackView.addArrangedSubview(passengerLabel)
        }

        passengersView.addSubview(passengersStackView)

        NSLayoutConstraint.activate([
            passengersStackView.topAnchor.constraint(equalTo: passengersView.topAnchor, constant: 20),
            passengersStackView.leadingAnchor.constraint(equalTo: passengersView.leadingAnchor, constant: 20),
            passengersStackView.trailingAnchor.constraint(equalTo: passengersView.trailingAnchor, constant: -20),
            passengersStackView.bottomAnchor.constraint(equalTo: passengersView.bottomAnchor, constant: -20)
        ])

        let crewLabel = UILabel()
        crewLabel.text = "Tripulação"
        crewLabel.font = .systemFont(ofSize: 18, weight: .bold)

        let crewStackView = UIStackView(arrangedSubviews: [crewLabel])
        crewStackView.axis = .vertical
        crewStackView.spacing = 8
        crewStackView.translatesAutoresizingMaskIntoConstraints = false

        for pilot in flight.pilots {
            let pilotLabel = UILabel()
            pilotLabel.text = "Piloto: \(pilot.name)"
            crewStackView.addArrangedSubview(pilotLabel)
        }

        for coPilot in flight.coPilots {
            let coPilotLabel = UILabel()
            coPilotLabel.text = "Co-Piloto: \(coPilot.name)"
            crewStackView.addArrangedSubview(coPilotLabel)
        }

        for attendant in flight.flightAttendants {
            let attendantLabel = UILabel()
            attendantLabel.text = "Comissário: \(attendant.name)"
            crewStackView.addArrangedSubview(attendantLabel)
        }

        crewView.addSubview(crewStackView)

        NSLayoutConstraint.activate([
            crewStackView.topAnchor.constraint(equalTo: crewView.topAnchor, constant: 20),
            crewStackView.leadingAnchor.constraint(equalTo: crewView.leadingAnchor, constant: 20),
            crewStackView.trailingAnchor.constraint(equalTo: crewView.trailingAnchor, constant: -20),
            crewStackView.bottomAnchor.constraint(equalTo: crewView.bottomAnchor, constant: -20)
        ])
    }
}
