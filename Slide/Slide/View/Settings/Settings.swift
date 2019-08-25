//
//  SettingsViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/5/19.
//          and Jennifer Kim :D
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

private let reuseIdentifier = "SettingsItem"

class Settings: UXView {
    
    // MARK: - PROPERTIES
    var menuHeader: SettingsHeader!
    
    // MARK: - INITIALIZATIONS
    
    override func viewDidLoad() {
        super.viewDidLoad(withTitle: "Settings")
        configureSettingsMenu()
    }
    
    // MARK: - CONFIGURATIONS
    
    func configureSettingsMenu() {
        
        view.backgroundColor = .white
        
        // setup the tableview
        let settingsMenu = UITableView()
        
        settingsMenu.delegate = self
        settingsMenu.dataSource = self
        
        settingsMenu.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(settingsMenu)
        
        settingsMenu.frame = view.frame
        settingsMenu.rowHeight = 60
        
        // frame for the header
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        menuHeader = SettingsHeader(frame: frame)
        settingsMenu.tableHeaderView = menuHeader
        
        // the rest of the table is contained within this view
        settingsMenu.tableFooterView = UIView()
    }
}

extension Settings: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // retrieves the section corresponding to the section index
        guard let section = SettingSection(rawValue: section) else { return 0 }
        
        switch section {
        case .General:
            return GeneralOption.allCases.count
        case .Manage:
            return ManageOption.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        
        // section that encompasses the cell at the index
        guard let section = SettingSection(rawValue: indexPath.section) else {return UITableViewCell()}

        // set the name of the cell by iterating through the appropriate enum
        switch section {
        case .General:
            let general = GeneralOption(rawValue: indexPath.row)
            cell.textLabel?.text = general?.description
        case .Manage:
            let manage = ManageOption(rawValue: indexPath.row)
            cell.textLabel?.text = manage?.description
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // cell designated for title descriptions
        let view = UIView()
        view.backgroundColor = UX.defaultColor
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingSection(rawValue: section)?.description
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    // action handler
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.cellForRow(at: indexPath)?.textLabel?.text {
        case "Edit Profile":
            print("edit profile")
        case "About":
            let about = About()
            present(UINavigationController(rootViewController: about), animated: true, completion: nil)
        case "Delete Account":
            AppUser.deleteUser(caller: self)
        default:
            print("ay")
        }
    }
}
