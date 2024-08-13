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

        // Exibir origem -> destino com um emoji de seta entre eles
        let originLabel = UILabel()
        originLabel.text = flight.origin
        originLabel.font = .systemFont(ofSize: 50, weight: .bold)

        let arrowLabel = UILabel()
        arrowLabel.text = "→"
        arrowLabel.font = .systemFont(ofSize: 40, weight: .bold)

        let destinationLabel = UILabel()
        destinationLabel.text = flight.destination
        destinationLabel.font = .systemFont(ofSize: 50, weight: .bold)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        let departureDateLabel = UILabel()
        departureDateLabel.text = "Data de ida: \(flight.departureDate)"

        let returnDateLabel = UILabel()
        returnDateLabel.text = "Data de volta: \(String(describing: flight.returnDate))"

        // StackView para origem -> destino
        let originDestinationStackView = UIStackView(arrangedSubviews: [originLabel, arrowLabel, destinationLabel])
        originDestinationStackView.axis = .horizontal
        originDestinationStackView.alignment = .center
        originDestinationStackView.spacing = 8

        // StackView para data de ida e volta
        let datesStackView = UIStackView(arrangedSubviews: [departureDateLabel, returnDateLabel])
        datesStackView.axis = .vertical
        datesStackView.spacing = 8

        // StackView final combinando todas as informações do voo
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
        passengersLabel.text = "Passageiros:"
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
        crewLabel.text = "Tripulação:"
        crewLabel.font = .systemFont(ofSize: 18, weight: .bold)

        let crewStackView = UIStackView(arrangedSubviews: [crewLabel])
        crewStackView.axis = .vertical
        crewStackView.spacing = 8
        crewStackView.translatesAutoresizingMaskIntoConstraints = false

        crewView.addSubview(crewStackView)

        NSLayoutConstraint.activate([
            crewStackView.topAnchor.constraint(equalTo: crewView.topAnchor, constant: 20),
            crewStackView.leadingAnchor.constraint(equalTo: crewView.leadingAnchor, constant: 20),
            crewStackView.trailingAnchor.constraint(equalTo: crewView.trailingAnchor, constant: -20),
            crewStackView.bottomAnchor.constraint(equalTo: crewView.bottomAnchor, constant: -20)
        ])
    }
}

