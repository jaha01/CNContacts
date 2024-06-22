//
//  ContactsTableViewCell.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 22.06.2024.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    static let identifier = "ContactsTableViewCell"
    
    // MARK: - Private properties
    
    private let name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private let phone: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public properties
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(name)
        contentView.addSubview(phone)
        contentView.clipsToBounds = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        name.frame = CGRect(x: 5, y: 0, width: contentView.frame.size.width, height: 2*contentView.frame.size.height/3)
        phone.frame = CGRect(x: 15, y: name.frame.height - 5, width: contentView.frame.size.width, height: contentView.frame.size.height/3)
    }
    
    func configure(contact: ContactItem) {
        name.text = contact.name
        phone.text = contact.phone
        switch contact.mobileOperator {
        case .megafone:
            contentView.backgroundColor = .systemGreen
        case .zetMobile:
            contentView.backgroundColor = .systemYellow
        case .babilon:
            contentView.backgroundColor = .systemBlue
        case .tcell:
            contentView.backgroundColor = .systemPurple
        default:
            contentView.backgroundColor = .white
        }
    }
    
}
