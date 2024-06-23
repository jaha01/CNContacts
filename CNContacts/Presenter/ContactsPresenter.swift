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
    func addContact(surname: String, name: String, phone: String)
    func deleteContact(phone: String)
    func setFilter(filter: Set<OperatorFilter>)
    func getFilters() -> Set<OperatorFilter>
}

final class ContactsPresenter: ContactsPresenterProtocol {
    
    weak var view: ContactsViewControllerProtocol!
    
    // MARK: Private properties
    
    private let contactStore = CNContactStore()
    private var contacts = [ContactItem]()
    private var operatorFilters: Set<OperatorFilter> = [.all]
    
    
    // MARK: - Public methods
    
    func onLoad() {
        CNContactStore().requestAccess(for: .contacts) { [weak self] success, error in
            guard let self = self else { return }
            if success {
                self.loadContacts()
            } else if error != nil {
                self.view.showEmptyView(message: "Access denied")
            }
        }
        return
    }
    
    func addContact(surname: String, name: String, phone: String) {
        let contact = CNMutableContact()
        
        contact.givenName = name
        contact.familyName = surname
        contact.phoneNumbers.append(CNLabeledValue(
            label: "mobile", value: CNPhoneNumber(stringValue: phone)))
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try? contactStore.execute(saveRequest)
        
        loadContacts()
    }
    
    func deleteContact(phone: String) {
        let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: phone))
        let toFetch = [CNContactEmailAddressesKey]
        
        do {
            let contacts = try contactStore.unifiedContacts(matching: predicate,keysToFetch: toFetch as [CNKeyDescriptor])
            guard contacts.count > 0 else{
                print("No contacts found")
                return
            }
            
            guard let contact = contacts.first else {
                return
            }
            
            let req = CNSaveRequest()
            let mutableContact = contact.mutableCopy() as! CNMutableContact
            req.delete(mutableContact)
            
            do {
                try contactStore.execute(req)
                print("Success, You deleted the user")
                loadContacts()
            } catch let e{
                print("Error = \(e)")
            }
        } catch let err{
            print(err)
        }
    }
    
    func setFilter(filter: Set<OperatorFilter>) {
        operatorFilters = filter
        loadContacts()
    }
    
    func getFilters() -> Set<OperatorFilter> {
        return operatorFilters
    }
    
    // MARK: - Private methods
    
    private func loadContacts() {
        do {
            contacts = [ContactItem]()
            let keyToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keyToFetch)
            let isAllInFilter = operatorFilters.contains(.all)
            try contactStore.enumerateContacts(with: request, usingBlock: { cnContact, error in
                if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
                    let name = CNContactFormatter.string(from: cnContact, style: .fullName) ?? ""
                    let phone = (cnContact.phoneNumbers[0].value).value(forKey: "digits") as? String ?? ""
                    let mobileOperator = self.getOperator(phone: phone)
                    if isAllInFilter || self.operatorFilters.contains(.operators(mobileOperator)) {
                        self.contacts.append(ContactItem(name: name, phone: phone, mobileOperator: mobileOperator))
                    }
                }
            })
            if contacts.isEmpty {
                view.showEmptyView(message: "There is no Contacts")
            } else {
                view.showContactsList(contacts: contacts)
            }
        }
        catch {
            view.showEmptyView(message: "Error getting Contacts data")
        }
    }
    
    private func getOperator(phone: String) -> MobileOperator {
        let phonePrefix = phone.prefix(2)
        
        if phone.prefix(3) == "918" || phonePrefix == "98"  {
            return MobileOperator.babilon
        } else if phonePrefix == "50" || phonePrefix == "93"  {
            return MobileOperator.tcell
        } else if phonePrefix == "91"  {
            return MobileOperator.zetMobile
        }  else if phonePrefix == "55" || phonePrefix == "90"  {
            return MobileOperator.megafone
        }
        return MobileOperator.unknown
    }
}
