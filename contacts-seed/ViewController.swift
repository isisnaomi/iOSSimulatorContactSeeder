//
//  ViewController.swift
//  contacts-seed
//
//  Created by Isis Naomi Ramirez on 3/15/19.
//  Copyright © 2019 Isis Naomi Ramirez. All rights reserved.
//

import UIKit
import AddressBook
import Contacts

class ViewController: UIViewController {
    var authDone = true
    
    @IBOutlet weak var startContactSeedButton: UIButton!
    
    @IBOutlet weak var numberContactsLabel: UITextField!
    @IBOutlet weak var areaCodeLabel: UITextField!
    @IBOutlet weak var digitsLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startContactSeedButton.addTarget(self, action: #selector(contactSeed), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func contactSeed(){
        let totalContacts = Int(numberContactsLabel.text ?? "0")!
            
        debugPrint("Contact seeding ...")
        AppDelegate.requestAccess{_ in
            for x in 0...totalContacts {
                debugPrint("Seeding contact  #\(x)")
                self.addRandomContact()
            }
        }
    }
    
    func addRandomContact(){
        let newContact = CNMutableContact()
        newContact.givenName = randomString(length: 10)
        let digits = Int(digitsLabel.text ?? "10")!
        let phoneNumber = "\(areaCodeLabel.text ?? "")\(randomPhone(length: digits)) "

        newContact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue: phoneNumber ))]
        do {
            let saveRequest = CNSaveRequest()
            saveRequest.add(newContact, toContainerWithIdentifier: nil)
            try AppDelegate.getAppDelegate().contactStore.execute(saveRequest)
        } catch {
            AppDelegate.getAppDelegate().showMessage("Unable to save the new contact.")
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func randomPhone(length: Int) -> String {
        let numbers = "0123456789"
        return String((0..<length).map{ _ in numbers.randomElement()! })
    }

}

