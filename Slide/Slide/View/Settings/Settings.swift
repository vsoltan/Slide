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

class Settings: UIViewController {
    
    // MARK: - PROPERTIES
    var menuHeader : SettingsHeader!
    
    // MARK: - INITIALIZATIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
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
    
    func configureNavigationController() {
        
        navigationController?.navigationBar.barTintColor = UX.defaultColor
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "streamline-icon-navigation-left-2@24x24").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackButton))
    }
    
    // MARK: - HANDLERS
    
    @objc func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension Settings : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        cell.textLabel?.text = "hello"
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
        title.text = "TITLE"
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
