//
//  ViewController.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 21.06.2024.
//

import UIKit
import Contacts

protocol ContactsViewControllerProtocol: AnyObject {
 func showContactsList(contacts: [CNContact])
 func showEmptyView(message: String)
}

final class ContactsViewController: UIViewController, ContactsViewControllerProtocol {

    var presenter: ContactsPresenterProtocol!
    
    // MARK: - Private properties
    
    private var contacts = [CNContact]()
    
    private let contactsList: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "1234567890"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Список контактов"
        view.addSubview(contactsList)
        view.addSubview(errorLabel)
        contactsList.isHidden = true
        errorLabel.isHidden = true
        contactsList.delegate = self
        contactsList.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(didFilterTap))

        presenter.onLoad()
        setConstraints()
    }
    
    func showContactsList(contacts: [CNContact]) {
        self.contacts = contacts
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.contactsList.isHidden = false
            self.errorLabel.isHidden = true
            self.contactsList.reloadData()
        }
        
    }
    
    func showEmptyView(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.contactsList.isHidden = true
            self.errorLabel.isHidden = false
            self.errorLabel.text = message
        }
    }

    // MARK: - Private methods
    
    @objc private func didTapAdd() {

    }

    @objc private func didFilterTap() {

    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            contactsList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactsList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contactsList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contactsList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }

}


extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "test"
        let contact = contacts[indexPath.row]
        if contact.areKeysAvailable([CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]) {
            cell.textLabel?.text = CNContactFormatter.string(from: contact, style: .fullName)
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            interactor.deleteItem(id: self.items[indexPath.row].id)
//            self.items.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
}
