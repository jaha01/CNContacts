//
//  ContactsFilterViewController.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 22.06.2024.
//

import UIKit

final class ContactsFilterViewController: UIViewController {

    // MARK: - Private properties
    
    private let zetSwitch: UISwitch = {
       let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemYellow
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()

    private let megafoneSwitch: UISwitch = {
       let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemGreen
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()
    
    private let babilonSwitch: UISwitch = {
       let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemBlue
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()
    
    private let tcellSwitch: UISwitch = {
       let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemPurple
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()
    
    private let allSwitch: UISwitch = {
       let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemGray
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.addTarget(self, action: #selector(allSwitchDidChanged), for: UIControl.Event.valueChanged)
        return mySwitch
    }()
    
    private let allLabel: UILabel = {
        let label = UILabel()
        label.text = "Все"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let zetLabel: UILabel = {
        let label = UILabel()
        label.text = "Зет-Мобайл"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let megafoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Мегафон"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tcellLabel: UILabel = {
        let label = UILabel()
        label.text = "Тселл"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let babilonLabel: UILabel = {
        let label = UILabel()
        label.text = "Вавилон"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
        view.backgroundColor = .systemBackground
        setupUI()
        
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(zetSwitch)
        view.addSubview(megafoneSwitch)
        view.addSubview(allSwitch)
        view.addSubview(babilonSwitch)
        view.addSubview(tcellSwitch)
        view.addSubview(allLabel)
        view.addSubview(zetLabel)
        view.addSubview(tcellLabel)
        view.addSubview(megafoneLabel)
        view.addSubview(babilonLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        NSLayoutConstraint.activate([
            
            allSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            allSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            allSwitch.trailingAnchor.constraint(equalTo: allSwitch.leadingAnchor, constant: 60),
            allSwitch.bottomAnchor.constraint(equalTo: allSwitch.topAnchor, constant: 40),
            allLabel.centerYAnchor.constraint(equalTo: allSwitch.centerYAnchor, constant: -5),
            allLabel.leadingAnchor.constraint(equalTo: allSwitch.trailingAnchor, constant: 20),
            
            zetSwitch.topAnchor.constraint(equalTo: allLabel.bottomAnchor, constant: 20),
            zetSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            zetSwitch.trailingAnchor.constraint(equalTo: zetSwitch.leadingAnchor, constant: 60),
            zetSwitch.bottomAnchor.constraint(equalTo: zetSwitch.topAnchor, constant: 40),
            zetLabel.centerYAnchor.constraint(equalTo: zetSwitch.centerYAnchor, constant: -5),
            zetLabel.leadingAnchor.constraint(equalTo: zetSwitch.trailingAnchor, constant: 20),
            
            megafoneSwitch.topAnchor.constraint(equalTo: zetLabel.bottomAnchor, constant: 20),
            megafoneSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            megafoneSwitch.trailingAnchor.constraint(equalTo: megafoneSwitch.leadingAnchor, constant: 60),
            megafoneSwitch.bottomAnchor.constraint(equalTo: megafoneSwitch.topAnchor, constant: 40),
            megafoneLabel.centerYAnchor.constraint(equalTo: megafoneSwitch.centerYAnchor, constant: -5),
            megafoneLabel.leadingAnchor.constraint(equalTo: megafoneSwitch.trailingAnchor, constant: 20),

            tcellSwitch.topAnchor.constraint(equalTo: megafoneLabel.bottomAnchor, constant: 20),
            tcellSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            tcellSwitch.trailingAnchor.constraint(equalTo: tcellSwitch.leadingAnchor, constant: 60),
            tcellSwitch.bottomAnchor.constraint(equalTo: tcellSwitch.topAnchor, constant: 40),
            tcellLabel.centerYAnchor.constraint(equalTo: tcellSwitch.centerYAnchor, constant: -5),
            tcellLabel.leadingAnchor.constraint(equalTo: tcellSwitch.trailingAnchor, constant: 20),

            babilonSwitch.topAnchor.constraint(equalTo: tcellLabel.bottomAnchor, constant: 20),
            babilonSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            babilonSwitch.trailingAnchor.constraint(equalTo: babilonSwitch.leadingAnchor, constant: 60),
            babilonSwitch.bottomAnchor.constraint(equalTo: babilonSwitch.topAnchor, constant: 40),
            babilonLabel.centerYAnchor.constraint(equalTo: babilonSwitch.centerYAnchor, constant: -5),
            babilonLabel.leadingAnchor.constraint(equalTo: babilonSwitch.trailingAnchor, constant: 20)

        ])
    }
    
    @objc private func allSwitchDidChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            megafoneSwitch.isOn = true
            babilonSwitch.isOn = true
            tcellSwitch.isOn = true
            zetSwitch.isOn = true
        } else {
            megafoneSwitch.isOn = false
            babilonSwitch.isOn = false
            tcellSwitch.isOn = false
            zetSwitch.isOn = false
        }
    }
    
    @objc private func didTapDone(mySwitch: UISwitch) {
        
    }

    @objc private func didTapCancel(mySwitch: UISwitch) {
        self.dismiss(animated: true, completion: nil)
    }

}
