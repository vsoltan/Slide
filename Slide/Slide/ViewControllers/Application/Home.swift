//
//  ViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Firebase

class Home: UIViewController {
    
    // MARK: - PROPERTIES
    var slideMenu : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHome()
    }
    
    // MARK: - CUSTOMIZATION

    let welcomeLabel : UILabel = {
        let dims = UIScreen.main.bounds.size
        let label  = UILabel(frame: CGRect(x: 20, y: 100, width: 200, height: 60))
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .black
        label.text = "Welcome,\n"
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - CONFIGURATION
    
    func configureHome() {
        // welcome page displays the user's name
        if let name = welcomeLabel.text {
            welcomeLabel.text = name + UserDefaults.standard.getName()
        }
        view.backgroundColor = .white
        view.addSubview(welcomeLabel)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Slide"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(toggleSideMenu))
    }
    
    func configureMenu() {
        // only creates the menu on startup
        if (slideMenu == nil) {
            slideMenu = Menu()
        }
    }
    
    // MARK : - HANDLERS
    
    @objc func toggleSideMenu() {
        print("hello")
    }
}

extension Home : HomeControllerDelegate {
    func toggleMenu() {
        configureMenu()
    }
}

