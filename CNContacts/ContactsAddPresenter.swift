//
//  ContactsAddPresenter.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 22.06.2024.
//

import Foundation
import Contacts

protocol ContactsAddPresenterProtocol: AnyObject {
    func addContact(name: String, surname: String, phone: String)
}

final class ContactsAddPresenter: ContactsAddPresenterProtocol {
   
    weak var view: ContactsAddViewControllerProtocol?
    
    // MARK: - Public methods
    
    func addContact(name: String, surname: String, phone: String) {
        let store = CNContactStore()
        let contact = CNMutableContact()

        contact.givenName = name
        contact.familyName = surname
        contact.phoneNumbers.append(CNLabeledValue(
            label: "mobile", value: CNPhoneNumber(stringValue: phone)))

        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
        view?.refreshTableView()
    }
    
}
