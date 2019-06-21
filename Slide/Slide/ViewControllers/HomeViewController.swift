//
//  ViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var NameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameLabel.attributedText = NSAttributedString(string: "HELLO WORLD", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        print(CurrentUser.getName())
    }
}
