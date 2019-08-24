//
//  ReceivedViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/27/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import AddressBook

class Received: UIViewController, CNContactViewControllerDelegate {
    
    var receivedInfo: EncodedMedia.Media?

    @IBOutlet weak var receivedInfoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        receivedInfoLabel.text = receivedInfo?.email!
        nameLabel.text = receivedInfo?.name!
    }
    
    @IBAction func createContact(_ sender: Any) {
        let newContact = contactDataScrape(data: receivedInfo!)
        
        if (addToAddressBook(contact: newContact)) {
            let contactVC = CNContactViewController(forNewContact: newContact)
            contactVC.delegate = self
            let navigationController = UINavigationController(rootViewController: contactVC)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            CustomError.createWith(errorTitle: "Something went wrong", errorMessage:
                "couldn't add contact to address book")
        }
    }
    
    func addToAddressBook(contact: CNMutableContact) -> Bool {
        let request = CNSaveRequest()
        let store = CNContactStore()
        
        request.add(contact, toContainerWithIdentifier: nil)
        do {
            try store.execute(request)
            return true
        } catch let err {
            print("Failed to save the contact. \(err)")
            return false
        }
    }

    func contactDataScrape(data: EncodedMedia.Media) -> CNMutableContact {
        
        // creating a mutable object to add to the contact
        let contact = CNMutableContact()
        
        // TODO retrieve profile picture
        // contact.imageData = NSData()
        
        // TODO fix bug where no last name is passed
        let fullName = TextParser.splitName(fullName: data.name!)
        contact.givenName = fullName.first
        contact.familyName = fullName.last
        
        let personalEmail = CNLabeledValue(label: "personal", value: data.email! as NSString)

        contact.emailAddresses = [personalEmail]
        
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile,
                                               value: CNPhoneNumber(stringValue: data.phoneNumber!))]
        
        return contact
    }
}

extension CNMutableContact {
    // TODO
//    func isDuplicate() -> Bool {
//    }
}
