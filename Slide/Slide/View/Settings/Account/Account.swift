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

class Accounts: UXView {
    
    // MARK: - PROPERTIES
    
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
    
    // MARK: - HANDLERS
    
    @objc func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension Accounts:  UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
//        return AccountsOption.allCases.count
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
    
//    // slide action to configure or remove account reference from user data
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let addAction = UITableViewRowAction(style: .default, title: "Configure" , handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
//        })
//        let removeAction = UITableViewRowAction(style: .destructive, title: "Delete" , handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
//            let removeMenu = UIAlertController(title: nil, message: "This will completely remove this media from your account, proceed?", preferredStyle: .actionSheet)
//
//            let continueAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//            removeMenu.addAction(continueAction)
//            removeMenu.addAction(cancelAction)
//
//            self.present(removeMenu, animated: true, completion: nil)
//        })
//        return [removeAction, addAction]
//    }
    
}

