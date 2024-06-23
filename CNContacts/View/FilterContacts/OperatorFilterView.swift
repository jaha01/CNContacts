//
//  OperatorFilterView.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 23.06.2024.
//

import Foundation
import UIKit

protocol OperatorFilterDelegate: AnyObject {
    func didChangeSwitch(operatorFilter: OperatorFilter, value: Bool)
}

final class OperatorFilterView: UIView {
    
    // MARK: - Public properties
    
    var isFilterActive: Bool {
        return operatorSwitch.isOn
    }
    
    weak var delegate: OperatorFilterDelegate?
    
    private let operatorFilter: OperatorFilter
    
    private let operatorSwitch: UISwitch = {
        let operatorSwitch = UISwitch()
        operatorSwitch.onTintColor = .systemGray
        operatorSwitch.translatesAutoresizingMaskIntoConstraints = false
        operatorSwitch.addTarget(self, action: #selector(switchDidChanged), for: UIControl.Event.valueChanged)
        return operatorSwitch
    }()
    
    private let operatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    init(operatorFilter: OperatorFilter) {
        self.operatorFilter = operatorFilter
        super.init(frame: .zero)
        setupUI()
        setupContent() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setSwitchValue(_ value: Bool) {
        operatorSwitch.isOn = value
    }
    
    // MARK: - Private methods
    
    @objc private func switchDidChanged() {
        delegate?.didChangeSwitch(operatorFilter: operatorFilter, value: operatorSwitch.isOn)
    }
    
    private func setupContent() {
        switch operatorFilter {
        case .all:
            operatorSwitch.onTintColor = .systemRed
            operatorLabel.text = "all"
        case .operators(let mobileOperator):
            switch mobileOperator {
            case .zetMobile:
                operatorSwitch.onTintColor = .systemYellow
                operatorLabel.text = "zetMobile"
            case .tcell:
                operatorSwitch.onTintColor = .systemPurple
                operatorLabel.text = "tcell"
            case .babilon:
                operatorSwitch.onTintColor = .systemBlue
                operatorLabel.text = "babilon"
            case .megafone:
                operatorSwitch.onTintColor = .systemGreen
                operatorLabel.text = "megafone"
            default:
                break
            }
        }
    }
    
    private func setupUI() {
        addSubview(operatorSwitch)
        addSubview(operatorLabel)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40),
            operatorSwitch.topAnchor.constraint(equalTo: topAnchor),
            operatorSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            operatorSwitch.widthAnchor.constraint(equalToConstant: 60),
            operatorSwitch.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            operatorLabel.leadingAnchor.constraint(equalTo: operatorSwitch.trailingAnchor, constant: 20),
            operatorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            operatorLabel.centerYAnchor.constraint(equalTo: operatorSwitch.centerYAnchor, constant: -4)
        ])
    }
}
