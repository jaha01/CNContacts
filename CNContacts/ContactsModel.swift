//
//  ContactsModel.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 22.06.2024.
//

import Foundation

struct ContactItem {
    var name: String
    var phone: String
    var mobileOperator: MobileOperator
}

enum MobileOperator {
    case zetMobile
    case tcell
    case babilon
    case megafone
    case unknown
}

enum OperatorFilter {
    case all
    case operators(MobileOperator)
}
