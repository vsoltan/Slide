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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do something
    }
    
    
}
