//
//  AppDelegate.swift
//  contacts-seed
//
//  Created by Isis Naomi Ramirez on 3/15/19.
//  Copyright © 2019 Isis Naomi Ramirez. All rights reserved.
//

import UIKit
import AddressBook
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var contactStore = CNContactStore()

    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    class func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            return
        case .restricted, .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                    }
                }
            }
        }
    }
    
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: "ALERT", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewController.present(alertController, animated: true, completion: nil)
    }

}

