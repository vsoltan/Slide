//
//  Menu.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/19/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class Menu: UIViewController {
    
    // MARK: - PROPERTIES
    
    var menuOptions : UITableView!
    var delegate : HomeControllerDelegate?
    private let reuseIdentifier = "MenuOptionCell"
    
    
    // MARK: - INITIALIZATION

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenu()
    }
    
    // MARK: -CONFIGURATION
    func configureMenu() {
        menuOptions = UITableView()
        menuOptions.delegate = self
        menuOptions.dataSource = self
        
        menuOptions.backgroundColor = .darkGray
        
        menuOptions.register(MenuOption.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(menuOptions)
        menuOptions.translatesAutoresizingMaskIntoConstraints = false
        menuOptions.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuOptions.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuOptions.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuOptions.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    // MARK: - HANDLERS
}

extension Menu : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOption
        return cell
    }
}
