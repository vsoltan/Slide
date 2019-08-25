//
//  AccountsViewController.swift
//  Slide
//
//  Created by Jennifer Kim on 7/3/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Accounts Item"

class Account: UXView {
    
    // MARK: - INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad(withTitle: "Account")
        configureMenu()
    }
    
    // MARK: - CONFIGUTATION
    func configureMenu() {
        
        view.backgroundColor = .white
        
        let accountsMenu = UITableView()
        accountsMenu.dataSource = self
        accountsMenu.delegate = self
        accountsMenu.frame = view.frame
        
        accountsMenu.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(accountsMenu)
    }
}

extension Account:  UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        // sets the text of that cell to the strings enumerated in the corresponding array
        cell.textLabel!.text = AccountsOption(rawValue: indexPath.row)?.description
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // performs an action upon selecting a specific cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let accountOption = AccountsOption(rawValue: indexPath.row) else { return }
        
        switch accountOption {
        case .PhoneNumber:
            print("phone number selected")
        case .Email:
            print("email selected")
        }
    }
}

