//
//  ReceivedViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/27/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Contacts
import AddressBook

class ReceivedViewController: UIViewController {
    
    var receivedInfo : EncodedMedia.Media?

    @IBOutlet weak var receivedInfoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        receivedInfoLabel.text = receivedInfo?.email!
        nameLabel.text = receivedInfo?.name!
    }
    
    @IBAction func createContact(_ sender: Any) {
        let newContact = contactDataScrape(data: receivedInfo!)
        do {
            let saveRequest = CNSaveRequest()
            // TODO actually add the new contact
            // also implement updating old contacts
//            saveRequest.add(saveRequest, toContainerWithIdentifier: nil)
        }
    }
    
    func contactDataScrape(data: EncodedMedia.Media) -> CNContact {
        
        // creating a mutable object to add to the contact
        let contact = CNMutableContact()
        
        // TODO retrieve profile picture
        // contact.imageData = NSData()
        
        print(data.name!)
//        let fullName = TextParser.splitName(fullName: data.name!)
//        contact.givenName = fullName.first
//        contact.familyName = fullName.last
        
        contact.givenName = "test"
        contact.familyName = "user"
        
        let personalEmail = CNLabeledValue(label: CNLabelHome, value: data.email! as NSString)

        contact.emailAddresses = [personalEmail]
        
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile,
                                               value: CNPhoneNumber(stringValue: data.phoneNumber!))]
        
        return contact
    }
}
