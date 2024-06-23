//
//  ContactsFilterViewController.swift
//  CNContacts
//
//  Created by Jahongir Anvarov on 22.06.2024.
//

import UIKit

protocol ContactsFilterDelegate: AnyObject {
    func applyFilters(filter: Set<OperatorFilter>)
}

final class ContactsFilterViewController: UIViewController, OperatorFilterDelegate {
    

    weak var delegate: ContactsFilterDelegate?
    
    // MARK: - Private properties
    
    private let allFilterSwitch = OperatorFilterView(operatorFilter: .all)
    private let zetFilterSwitch = OperatorFilterView(operatorFilter: .operators(.zetMobile))
    private let megafoneFilterSwitch = OperatorFilterView(operatorFilter: .operators(.megafone))
    private let babilonFilterSwitch = OperatorFilterView(operatorFilter: .operators(.babilon))
    private let tcellFilterSwitch = OperatorFilterView(operatorFilter: .operators(.tcell))
    
    // MARK: - Init
    
    init(activeFilters: Set<OperatorFilter>, delegate: ContactsFilterDelegate){
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        setupUI()
        if activeFilters.contains(.all) {
            zetFilterSwitch.setSwitchValue(true)
            megafoneFilterSwitch.setSwitchValue(true)
            babilonFilterSwitch.setSwitchValue(true)
            tcellFilterSwitch.setSwitchValue(true)
            allFilterSwitch.setSwitchValue(true)
        } else {
            zetFilterSwitch.setSwitchValue(activeFilters.contains(.operators(.zetMobile)))
            megafoneFilterSwitch.setSwitchValue(activeFilters.contains(.operators(.megafone)))
            babilonFilterSwitch.setSwitchValue(activeFilters.contains(.operators(.babilon)))
            tcellFilterSwitch.setSwitchValue(activeFilters.contains(.operators(.tcell)))
            allFilterSwitch.setSwitchValue(false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
        view.backgroundColor = .systemBackground
    }
    
    func didChangeSwitch(operatorFilter: OperatorFilter, value: Bool) {
        switch operatorFilter {
        case .all:
            zetFilterSwitch.setSwitchValue(value)
            megafoneFilterSwitch.setSwitchValue(value)
            babilonFilterSwitch.setSwitchValue(value)
            tcellFilterSwitch.setSwitchValue(value)
        case .operators:
            let isAllFiltersActive = zetFilterSwitch.isFilterActive && tcellFilterSwitch.isFilterActive && babilonFilterSwitch.isFilterActive && megafoneFilterSwitch.isFilterActive
            allFilterSwitch.setSwitchValue(isAllFiltersActive)
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(allFilterSwitch)
        view.addSubview(zetFilterSwitch)
        view.addSubview(megafoneFilterSwitch)
        view.addSubview(babilonFilterSwitch)
        view.addSubview(tcellFilterSwitch)

        allFilterSwitch.delegate = self
        zetFilterSwitch.delegate = self
        megafoneFilterSwitch.delegate = self
        babilonFilterSwitch.delegate = self
        tcellFilterSwitch.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        allFilterSwitch.translatesAutoresizingMaskIntoConstraints = false
        zetFilterSwitch.translatesAutoresizingMaskIntoConstraints = false
        megafoneFilterSwitch.translatesAutoresizingMaskIntoConstraints = false
        babilonFilterSwitch.translatesAutoresizingMaskIntoConstraints = false
        tcellFilterSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            allFilterSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            allFilterSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            allFilterSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            zetFilterSwitch.topAnchor.constraint(equalTo: allFilterSwitch.bottomAnchor, constant: 12),
            zetFilterSwitch.leadingAnchor.constraint(equalTo: allFilterSwitch.leadingAnchor),
            zetFilterSwitch.trailingAnchor.constraint(equalTo: allFilterSwitch.trailingAnchor),
            
            megafoneFilterSwitch.topAnchor.constraint(equalTo: zetFilterSwitch.bottomAnchor, constant: 12),
            megafoneFilterSwitch.leadingAnchor.constraint(equalTo: allFilterSwitch.leadingAnchor),
            megafoneFilterSwitch.trailingAnchor.constraint(equalTo: allFilterSwitch.trailingAnchor),
            
            babilonFilterSwitch.topAnchor.constraint(equalTo: megafoneFilterSwitch.bottomAnchor, constant: 12),
            babilonFilterSwitch.leadingAnchor.constraint(equalTo: allFilterSwitch.leadingAnchor),
            babilonFilterSwitch.trailingAnchor.constraint(equalTo: allFilterSwitch.trailingAnchor),
            
            tcellFilterSwitch.topAnchor.constraint(equalTo: babilonFilterSwitch.bottomAnchor, constant: 12),
            tcellFilterSwitch.leadingAnchor.constraint(equalTo: allFilterSwitch.leadingAnchor),
            tcellFilterSwitch.trailingAnchor.constraint(equalTo: allFilterSwitch.trailingAnchor)
        ])
    }
    
    
    @objc private func didTapDone(sender: UISwitch) {
        var operatorFilters: Set<OperatorFilter> = []
        
        if allFilterSwitch.isFilterActive {
            operatorFilters.insert(.all)
        } else {
            if megafoneFilterSwitch.isFilterActive {
                operatorFilters.insert(.operators(.megafone))
            }
            if babilonFilterSwitch.isFilterActive {
                operatorFilters.insert(.operators(.babilon))
            }
            if zetFilterSwitch.isFilterActive {
                operatorFilters.insert(.operators(.zetMobile))
            }
            if tcellFilterSwitch.isFilterActive {
                operatorFilters.insert(.operators(.tcell))
            }
        }        
        delegate?.applyFilters(filter: operatorFilters)
        close()
    }

    @objc private func didTapCancel(sender: UISwitch) {
        close()
    }

    private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
