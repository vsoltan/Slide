//
//  ManageViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/26/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class ManageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // constant for the number of sections in the settings table
    let numSections = 1
    
    // sections of the table
    let manageArray = ["Delete Account"]
    
    @IBOutlet weak var manageTable: UITableView!
    
    // initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        manageTable.dataSource = self
        manageTable.delegate = self
    }
    
    // returns the number of cells in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //place holder
        return 1
    }

    // creates the labels in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // retrieves a cell from the table given the index
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageItem", for: indexPath)
        // sets the text of that cell to the strings enumerated in the corresponding array
        cell.textLabel!.text = manageArray[0]
        return cell
    }
    
    // cell activation handler
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if a row is clicked, unclick and give it a fade out animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        // check if Delete Account was clicked
        if (indexPath.row == 0) {
            SlideUser.deleteUser(caller: self)
        }
    }
}
