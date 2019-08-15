//
//  CreateViewController.swift
//  Slide
//
//  Created by Sam Lee on 7/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsItem", for: indexPath)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
