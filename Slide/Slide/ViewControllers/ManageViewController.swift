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
    
    
    @IBOutlet weak var ManageTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //place holder
        return 1


    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // retrieves a cell from the table given the index
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageItem", for: indexPath)
        // sets the text of that cell to the strings enumerated in the corresponding array
        cell.textLabel!.text = manageArray[0]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
