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
    
    // MARK: -CUSTOMIZATION

    let welcomeLabel : UILabel = {
        let dims = UIScreen.main.bounds.size
        let label  = UILabel(frame: CGRect(x: 0, y: 100, width: 200, height: 60))
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .white
        label.text = "Welcome,\n"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHome()
    }
    
    func configureHome() {
        // welcome page displays the user's name
        if let name = welcomeLabel.text {
            welcomeLabel.text = name + UserDefaults.standard.getName()
        }
        view.backgroundColor = .gray
        view.addSubview(welcomeLabel)
        
        // TODO add navigation controller
    }
}

