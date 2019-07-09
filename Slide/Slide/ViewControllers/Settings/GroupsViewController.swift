//
//  GroupsViewController.swift
//  Slide
//
//  Created by Sam Lee on 7/3/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var db: Firestore!
    
    // constant for the number of sections in the groups table
    let numSections = 1
    
    @IBAction func createNew(_ sender: Any) {
        // TODO: Set data
    }
    // retrieve groups created by the user from database
    // TODO: deal with the whole asynchronous thing
    func getGroups() {
        let docRef = db.collection("users").document("groups")
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                // TODO: Replace with call to get data in an actually usable format (i.e. custom struct?)
                let groups = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(groups)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: return number of groups as found in database
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsItem", for: indexPath)
        
        // TODO: set cell text according to group names as found in database
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
    }
    
    // TODO: Create a click handler (see SettingsViewController for reference)
    
}
