//
//  Settings.swift
//  JahanCo Catalog
//
//  Created by Vahid Ghanbarpour on 8/10/17.
//  Copyright © 2017 Vahid Ghanbarpour. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class Settings: UITableViewController, CNContactPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "تنظیمات"
    }

    @IBAction func commonQuestions(_ sender: UIButton) {
        let url = URL(string: "https://jahanco.net/")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareWithColleaguesPressed(_ sender: UIButton) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    //Works, but only allows me to select one at a time
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print(contact.phoneNumbers)
        print("WYASDFY")
    }
    
    //This function never runs :/
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        print(contacts)
        contacts.forEach { contact in
            for number in contact.phoneNumbers {
                let phoneNumber = number.value
                print("number is = \(phoneNumber)")
            }
        }
    }    
}
