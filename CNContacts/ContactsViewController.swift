//
//  ViewController.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 21.06.2024.
//

import UIKit
import Contacts

protocol ContactsViewControllerProtocol: AnyObject {
 func showContactsList(contacts: [ContactItem])
 func showEmptyView(message: String)
}

protocol ContactsTableRefreshProtocol: AnyObject {
    func refreshTable()
}

final class ContactsViewController: UIViewController, ContactsViewControllerProtocol, ContactsTableRefreshProtocol {

    var presenter: ContactsPresenterProtocol!
    
    // MARK: - Private properties
    
    private var contacts = [ContactItem]()
    
    private let contactsList: UITableView = {
        let table = UITableView()
        table.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Список контактов"
        contactsList.delegate = self
        contactsList.dataSource = self
        setupUI()
        refreshTable()
    }
    
    func showContactsList(contacts: [ContactItem]) {
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

    func refreshTable() {
        presenter.onLoad()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.addSubview(contactsList)
        view.addSubview(errorLabel)
        contactsList.isHidden = true
        errorLabel.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapFilter))
        setConstraints()
    }
    
    @objc private func didTapAdd() {
        let contactAddController = ContactsAddViewController(delegate: self)
        let contactAddPresenter = ContactsAddPresenter()
        
        contactAddPresenter.view = contactAddController
        contactAddController.presenter = contactAddPresenter
        
        let nav = UINavigationController(rootViewController: contactAddController)
        nav.navigationBar.backgroundColor = .white
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 25
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        self.present(nav, animated: true, completion: nil)
    }

    @objc private func didTapFilter() {
        let filterVC = ContactsFilterViewController()
        let nav = UINavigationController(rootViewController: filterVC)
        nav.navigationBar.backgroundColor = .white
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 25
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        self.present(nav, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as! ContactsTableViewCell
        cell.configure(contact: contacts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteContact()
            
        }
    }
}
