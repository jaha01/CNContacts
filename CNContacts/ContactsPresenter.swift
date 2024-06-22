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
    func addContact(surname: String, name: String, phone: String)
    func deleteContact()
    func setFilter(filter: [MobileOperator])
}

final class ContactsPresenter: ContactsPresenterProtocol {
    
    weak var view: ContactsViewControllerProtocol!
    
    // MARK: Private properties
    
    private var contactStore = CNContactStore()
    private var contacts = [ContactItem]()
    private var operatorFilter = [MobileOperator.tcell, MobileOperator.zetMobile, MobileOperator.megafone, MobileOperator.babilon]
    
    
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
    
    
    func applyFilters() {
        
    }
    
    func addContact(surname: String, name: String, phone: String) {
        let store = CNContactStore()
        let contact = CNMutableContact()

        contact.givenName = name
        contact.familyName = surname
        contact.phoneNumbers.append(CNLabeledValue(
            label: "mobile", value: CNPhoneNumber(stringValue: phone)))

        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
        
        loadContacts()
    }
    
    func deleteContact() {
        let predicate = CNContact.predicateForContacts(matchingName: "John")
        let toFetch = [CNContactEmailAddressesKey]

        do{
          let contacts = try store.unifiedContactsMatchingPredicate(predicate,keysToFetch: toFetch)
          guard contacts.count > 0 else{
            print("No contacts found")
            return
          }

          guard let contact = contacts.first else{

        return
          }

          let req = CNSaveRequest()
          let mutableContact = contact.mutableCopy() as! CNMutableContact
          req.deleteContact(mutableContact)

          do{
            try store.executeSaveRequest(req)
            print("Success, You deleted the user")
          } catch let e{
            print("Error = \(e)")
          }
        } catch let err{
           print(err)
        }
    }
    
    func setFilter(filter: [MobileOperator]) {
        operatorFilter = filter
        loadContacts()
    }
    
    // MARK: - Private methods
    
    private func loadContacts() {
        do {
            contacts = [ContactItem]()
            let keyToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keyToFetch)
            try contactStore.enumerateContacts(with: request, usingBlock: { cnContact, error in
                if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
                    let name = CNContactFormatter.string(from: cnContact, style: .fullName) ?? ""
                    let phone = (cnContact.phoneNumbers[0].value).value(forKey: "digits") as? String ?? ""
                    let mobileOperator = self.getOperator(phone: phone)
                    if self.operatorFilter.contains(mobileOperator) {
                        self.contacts.append(ContactItem(name: name, phone: phone, mobileOperator: mobileOperator))
                    }
                }
            })
            view.showContactsList(contacts: contacts)
        }
        catch {
            view.showEmptyView(message: "Error getting Contacts data")
        }
    }
    
    private func getOperator(phone: String) -> MobileOperator {
        let phonePrefix = phone.prefix(2)
        if phonePrefix == "50" || phonePrefix == "93"  {
            return MobileOperator.tcell
        } else if phonePrefix == "91"  {
            return MobileOperator.zetMobile
        } else if phone.prefix(3) == "918" || phonePrefix == "98"  {
            return MobileOperator.babilon
        } else if phonePrefix == "55" || phonePrefix == "90"  {
            return MobileOperator.megafone
        }
        return MobileOperator.unknown
    }
}
