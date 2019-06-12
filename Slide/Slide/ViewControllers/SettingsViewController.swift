//
//  SettingsViewController.swift
//  Slide
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    let profileArray = ["Linked Media", "Cards", "Friends"]
    
    let accountArray = ["Password", "Upgrade"]
    
    let supportArray = ["About", "Contact", "Ratings", "Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.dataSource = self
        settingsTable.delegate = self
        
        print("Settings page loaded")
        // Do any additional setup after loading the view.
    }
    
    // MARK: - TABLEVIEW DELEGATE & DATASOURCE
    
    // How many sections?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // How many cells in each section?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        if section == 0 {
            num = profileArray.count
        } else if section == 1 {
            num = accountArray.count
        } else if section == 2 {
            num = supportArray.count
        }
        return num
    }
    
    // What are the cells' contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsItem", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel!.text = profileArray[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel!.text = accountArray[indexPath.row]
        } else if indexPath.section == 2 {
            cell.textLabel!.text = supportArray[indexPath.row]
        }
        
        return cell
    }
    
    // Create section titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Profile"
        } else if section == 1 {
            return "Account"
        } else {
            return "Support"
        }
    }

}
