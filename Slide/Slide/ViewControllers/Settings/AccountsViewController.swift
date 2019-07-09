//
//  AccountsViewController.swift
//  Slide
//
//  Created by Jennifer Kim on 7/3/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct cellProperty {
    let isOpened : Bool
}


class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // constant for the number of sections in the settings table
    let numSections = 1
    
    // accounts in the table
    let accountsArray = ["Phone Number", "Email", "Instagram", "Snapchat", "Facebook"]
    
    // table object
    @IBOutlet weak var accountsTable: UITableView!
    
    // returns the number of sections for the table
    func numberOfSections(in tableView: UITableView) -> Int {
        return numSections
    }
    
    // returns the number of cells in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsArray.count
    }
    
    // retrieves the cell from the table given the index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // gets a reference to the cell in the table
        let cell = tableView.dequeueReusableCell(withIdentifier: "Accounts Item", for: indexPath)
        
        // sets the text of that cell to the strings enumerated in the corresponding array
        cell.textLabel!.text = accountsArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    // performs an action upon selecting a specific cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if a row is clicked, unclick and give it a fade out animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        // determines what page to segue to based on which cell is clicked
        let segueLabel = accountsArray[indexPath.row]
        
        // array of all actionable pages
        let tabs = ["Phone Number"]
        
        // executes the segue corresponding to the tab selected
        if let index = tabs.firstIndex(of: segueLabel) {
            performSegue(withIdentifier: segueLabel, sender: self)
            print(index) // make compiler happy
        }
    }
    
    // slide action to configure or remove account reference from user data
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addAction = UITableViewRowAction(style: .default, title: "Configure" , handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
        })
        let removeAction = UITableViewRowAction(style: .destructive, title: "Delete" , handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            let removeMenu = UIAlertController(title: nil, message: "This will completely remove this media from your account, proceed?", preferredStyle: .actionSheet)

            let continueAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            removeMenu.addAction(continueAction)
            removeMenu.addAction(cancelAction)

            self.present(removeMenu, animated: true, completion: nil)
        })
        return [removeAction, addAction]
    }
    
    // initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        accountsTable.dataSource = self
        accountsTable.delegate = self
    }
    
}

