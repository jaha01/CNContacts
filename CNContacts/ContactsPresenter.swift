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
//    func addContact()
    func deleteContact()
}

final class ContactsPresenter: ContactsPresenterProtocol {
    
    weak var view: ContactsViewControllerProtocol!
    
    // MARK: Private properties
    
    private var contactStore = CNContactStore()
    private var contacts = [ContactItem]()
    
    
    // MARK: - Public methods
    
    func onLoad() {
        CNContactStore().requestAccess(for: .contacts) { [weak self] success, error in
            guard let self = self else { return }
            if success {
                self.loadContacts()
            } else if error != nil {
                self.view.showEmptyView(message: "Access denied")
                return
            }
        }
    }
    
    
    func applyFilters() {
        
    }
    
//    func addContact() {
//        let store = CNContactStore()
//        let contact = CNMutableContact()
//
//        contact.givenName = name
//        contact.familyName = surname
//        contact.phoneNumbers.append(CNLabeledValue(
//            label: "mobile", value: CNPhoneNumber(stringValue: phone)))
//
//        let saveRequest = CNSaveRequest()
//        saveRequest.add(contact, toContainerWithIdentifier: nil)
//        try? store.execute(saveRequest)
//    }
    
    func deleteContact() {
        
    }
    
    // MARK: - Private methods
    
    private func loadContacts() {
        do {
            contacts = [ContactItem]()
            let keyToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keyToFetch)
            try contactStore.enumerateContacts(with: request, usingBlock: { cnContact, error in
                if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
                    let name = CNContactFormatter.string(from: cnContact, style: .fullName)!
                    let phone = (cnContact.phoneNumbers[0].value as! CNPhoneNumber).value(forKey: "digits") as! String
                    let operatr = self.getOperator(phone: phone)
                    self.contacts.append(ContactItem(name: name, phone: phone, mobileOperator: operatr))
                }
            })
            view.showContactsList(contacts: contacts)
        }
        catch {
            view.showEmptyView(message: "Error getting Contacts data")
        }
    }
    
    private func getOperator(phone: String) -> MobileOperator {
        if phone.prefix(2) == "50" || phone.prefix(2) == "93"  {
            return MobileOperator.tcell
        } else if phone.prefix(2) == "91"  {
            return MobileOperator.zetMobile
        } else if phone.prefix(3) == "918" || phone.prefix(2) == "98"  {
            return MobileOperator.babilon
        } else if phone.prefix(2) == "55" || phone.prefix(2) == "90"  {
            return MobileOperator.megafone
        }
        return MobileOperator.unknown
    }
}
