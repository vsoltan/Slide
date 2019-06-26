//
//  SettingsViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // constant for the number of sections in the settings table
    let numSections = 3
    
    // sections of the table
    let profileArray = ["Linked Media", "Cards", "Friends"]
    
    let accountArray = ["Change Password", "Upgrade"]
    
    let supportArray = ["About", "Contact", "Ratings", "Logout"]
    
    let titles = ["Profile", "Account", "Support"]
    
    // cumulative array with all sections for easy access in methods
    lazy var allSections : Array<Array<String>> = [profileArray, accountArray, supportArray]

    // table object
    @IBOutlet weak var settingsTable: UITableView!
    
    // initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.dataSource = self
        settingsTable.delegate = self
    }
    
    // returns the number of sections for the table
    func numberOfSections(in tableView: UITableView) -> Int {
        return numSections
    }
    
    // returns the number of cells in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSections[section].count
    }
    
    // creates the labels in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // retrieves a cell from the table given the index
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsItem", for: indexPath)
        // sets the text of that cell to the strings enumerated in the corresponding array
        cell.textLabel!.text = allSections[indexPath.section][indexPath.row]
        
        return cell
    }

    // sets the section titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section];
    }
    
    // cell click handler
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if a row is clicked, unclick and give it a fade out animation
        tableView.deselectRow(at: indexPath, animated: true)
        // special case to handle "Log out"
        if (indexPath.section == 2 && indexPath.row == 3 ) {
            print ("We did it")
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                if (firebaseAuth.currentUser == nil) {
                    print ("Successfully signed out!")
                }
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
        }
        // determines what page to segue to based on which cell is clicked
        let segueLabel = allSections[indexPath.section][indexPath.row]
        
        // Dev only: Temporary array of completed pages
        let completed = ["Logout", "Change Password"]
        
        // Dev only: Temporary case handling for performSegue to avoid calling nonexistent segues
        if let index = completed.firstIndex(of: segueLabel) {
            performSegue(withIdentifier: segueLabel, sender: self)
            print(index) // make compiler happy
        }
    }
    
}
