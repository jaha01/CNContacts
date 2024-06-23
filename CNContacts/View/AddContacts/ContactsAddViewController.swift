//
//  ContactsAddViewController.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 22.06.2024.
//

import UIKit


final class ContactsAddViewController: UIViewController {

    weak var delegate: ContactsViewController?
    
    // MARK: - Private properties
    
    private let surname: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "   Фамилия"
        textfield.backgroundColor = .secondarySystemBackground
        textfield.layer.cornerRadius = 10
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let name: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "   Имя"
        textfield.backgroundColor = .secondarySystemBackground
        textfield.layer.cornerRadius = 10
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let phone: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "   Телефон"
        textfield.backgroundColor = .secondarySystemBackground
        textfield.layer.cornerRadius = 10
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    // MARK: - Init
    
    init(delegate: ContactsViewController){
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить Контакт"
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(surname)
        view.addSubview(name)
        view.addSubview(phone)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        NSLayoutConstraint.activate([
            surname.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            surname.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            surname.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            surname.bottomAnchor.constraint(equalTo: surname.topAnchor, constant: 40),
            
            name.topAnchor.constraint(equalTo: surname.bottomAnchor, constant: 12),
            name.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            name.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            name.bottomAnchor.constraint(equalTo: name.topAnchor, constant: 40),
            
            phone.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 12),
            phone.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            phone.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            phone.bottomAnchor.constraint(equalTo: phone.topAnchor, constant: 40),
            ])
    }
    
    @objc private func didTapDone() {
        delegate?.addContact(surname: surname.text ?? "", name: name.text ?? "", phone: phone.text ?? "")
        close()
    }

    @objc private func didTapCancel() {
        close()
    }
    
    private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
