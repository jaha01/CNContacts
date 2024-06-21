//
//  ContactsPresenter.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 21.06.2024.
//

import Foundation
import Contacts

protocol ContactsPresenterProtocol: AnyObject {
    func onLoad()
    func applyFilters()
    func addContact()
    func deleteContact()
}

final class ContactsPresenter: ContactsPresenterProtocol {
    
    weak var view: ContactsViewControllerProtocol!
    
    // MARK: Private properties
    
    private var contactStore = CNContactStore()
    private var contacts = [CNContact]()
    
    
    // MARK: - Public methods
    
    func onLoad() {
        CNContactStore().requestAccess(for: .contacts) { [weak self] success, error in
            guard let self = self else { return }
            guard success else {
                self.view.showEmptyView(message: "Access denied")
                return
            }
            self.loadContacts()
//            self.view.showContactsList(contacts: self.contacts)
        }
    }
    
    func loadContacts() {
        do {
            contacts = [CNContact]()
            let keyToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactImageDataKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keyToFetch)
            try contactStore.enumerateContacts(with: request, usingBlock: { [weak self] cnContact, error in
                guard let self = self else { return }
                if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
                    self.contacts.append(cnContact)
//                    for entry in cnContact.phoneNumbers {
//                        let strValue = entry.value as CNPhoneNumber
//                        if !strValue.isEmpty {
//
//                            break
//                        }
//                    }
                }
            })
            view.showContactsList(contacts: contacts)
        }
        catch {
            view.showEmptyView(message: "Error getting Contacts data")
        }
    }
    
    func applyFilters() {
        
    }
    
    func addContact() {
        
    }
    
    func deleteContact() {
        
    }
    
}
