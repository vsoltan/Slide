//
//  ProtectedViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class ProtectedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // upon opening the protected view controller, segue is performed
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "ToLogin", sender: self)
    }

}
