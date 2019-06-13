//
//  ProtectedViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class ProtectedViewController: UIViewController {

    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // upon opening the protected view controller, segue is performed
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "ToLogin", sender: self)
    }
}
