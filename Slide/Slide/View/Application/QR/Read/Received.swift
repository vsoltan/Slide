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

class Received: UIViewController {
    
    // MARK: - PROPERTIES
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add New"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "synchronize the contents of this Slide\n with your social networks and contacts!"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let createContactButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UX.defaultColor
        button.setTitle("Create New Contact", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UX.defaultColor
        button.setTitle("Done", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var receivedInfo: EncodedMedia.Media?
    
    // MARK: - CONFIGURATION
    
    func configureRecieved() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true

        view.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(createContactButton)
        createContactButton.addTarget(self, action: #selector(handleCreateContactButton), for: .touchUpInside)
        createContactButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createContactButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: createContactButton.bottomAnchor, constant: 30).isActive = true
    }
    
    // generates labels for all information shared
    func generateSharedLabels() {
        
        guard let received = receivedInfo else { return }
        
        let sharedMedia: Array<(key: String, value: String?)> = [
            ("Name", received.name), ("Email", received.email),
            ("Phone", received.phoneNumber),
        ]
        
        var labelOffset: CGFloat = 50
        
        for tuple in sharedMedia {
            if let value = tuple.value {
                let label = UILabel()
                
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = tuple.key + ": \(value)"
                view.addSubview(label)
                
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                label.topAnchor.constraint(equalTo: createContactButton.topAnchor, constant: labelOffset).isActive = true
                labelOffset = labelOffset + 50
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecieved()
        //generateSharedLabels()
    }
    
    func addToAddressBook(contact: CNMutableContact) {
        let request = CNSaveRequest()
        let store = CNContactStore()
        
        request.add(contact, toContainerWithIdentifier: nil)
        do {
            try store.execute(request)
        } catch let err {
            print("Failed to save the contact. \(err)")
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
        
        if let ayyy = data.phoneNumber {
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile,
                                                   value: CNPhoneNumber(stringValue: ayyy))]
        }
        return contact
    }
    
    // MARK: - HANDLERS
    @objc func handleCreateContactButton() {
        let newContact = contactDataScrape(data: receivedInfo!)
        
        let contactView = CNContactViewController(forNewContact: newContact)
        contactView.delegate = self
        let navigationController = UINavigationController(rootViewController: contactView)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func handleDoneButton() {
        let container = Container()
        present(container, animated: true, completion: nil)
    }
}

extension Received: CNContactViewControllerDelegate{
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        if let contact = contact {
            addToAddressBook(contact: contact.mutableCopy() as! CNMutableContact)
        }
        viewController.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }

    // TODO
    // func isDuplicate() -> Bool {
    // }
}
