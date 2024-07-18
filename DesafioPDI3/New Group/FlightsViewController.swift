//
//  FlightsViewController.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 17/07/24.
//

import Foundation
import UIKit

class FlightsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Voos"
        
        setupNavigationBar()
        setupNoFlightsLabel()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFlightTapped))
    }
    
    private func setupNoFlightsLabel() {
        let noFlightsLabel = UILabel()
        noFlightsLabel.text = "Nenhum voo adicionado"
        noFlightsLabel.textAlignment = .center
        noFlightsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noFlightsLabel)
        
        NSLayoutConstraint.activate([
            noFlightsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFlightsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func addFlightTapped() {
        let newFlightVC = NewFlightViewController()
        navigationController?.pushViewController(newFlightVC, animated: true)
    }
}
