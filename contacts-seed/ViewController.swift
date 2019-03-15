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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startContactSeedButton.addTarget(self, action: #selector(contactSeed), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func contactSeed(){
        debugPrint("Contact seeding ...")
        AppDelegate.requestAccess{_ in
            for x in 0...1500 {
                debugPrint("Seeding contact  #\(x)")
                self.addRandomContact()
            }
        }
    }
    
    func addRandomContact(){
        let newContact = CNMutableContact()
        newContact.givenName = randomString(length: 10)

        newContact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:randomPhone(length: 10)))]
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

