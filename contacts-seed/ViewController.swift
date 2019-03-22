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
import ContactsUI

class ViewController: UIViewController {
    var authDone = true
    var seededContactsPhones: [String] = []
    var seededContactsNames: [String] = []

    @IBOutlet weak var startContactSeedButton: UIButton!
    
    @IBOutlet weak var revertContactSeed: UIButton!
    @IBOutlet weak var numberContactsLabel: UITextField!
    @IBOutlet weak var areaCodeLabel: UITextField!
    @IBOutlet weak var digitsLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        startContactSeedButton.addTarget(self, action: #selector(contactSeed), for: .touchUpInside)
        revertContactSeed.addTarget(self, action: #selector(removeLastSeed), for: .touchUpInside)
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
    
    @objc func removeLastSeed(){
        debugPrint("revert seeding ...")
        AppDelegate.requestAccess{_ in
            for x in 0 ... self.seededContactsNames.count - 1 {
                debugPrint("revert contact  #\(x)")
                let predicate = CNContact.predicateForContacts(matchingName: self.seededContactsNames[x])
                let store = CNContactStore()
                let keysToFetch = [CNContactViewController.descriptorForRequiredKeys()]
                do {
                    let fetchedContacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                    fetchedContactsIterator : for filteredContact in fetchedContacts {
                        self.deleteContact(contact: filteredContact)
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteContact(contact: CNContact){
        do {
            let mutableContact = contact.mutableCopy() as! CNMutableContact
            let deleteRequest = CNSaveRequest()
            deleteRequest.delete(mutableContact)
            try AppDelegate.getAppDelegate().contactStore.execute(deleteRequest)
        } catch {
            AppDelegate.getAppDelegate().showMessage("Unable to delete the contact.")
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
            seededContactsPhones.append(phoneNumber)
            seededContactsNames.append(newContact.givenName)

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

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

