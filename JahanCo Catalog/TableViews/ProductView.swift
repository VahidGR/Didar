//
//  ProductTable.swift
//  JahanCo Catalog
//
//  Created by Vahid Ghanbarpour on 7/29/17.
//  Copyright © 2017 Vahid Ghanbarpour. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductView: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTextView: UITextView!
    @IBOutlet weak var pfImage1: UIImageView!
    @IBOutlet weak var pfImage2: UIImageView!
    @IBOutlet weak var pfImage3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = UserDefaults.standard.string(forKey: "username")
        let password = UserDefaults.standard.string(forKey: "password")
        if username == nil || password == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        }
    }
    
    @objc func share() {
        /*
        https://telegram.me/share/url?url=<URL>&text=<TEXT>
        tg://msg?text=Mi_mensaje&to=+1555999
        
        let urlString = "tg://msg?text=test"
        let tgUrl = URL.init(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if UIApplication.shared.canOpenURL(tgUrl!) {
            UIApplication.shared.openURL(tgUrl!)
        } else {
         let alert = UIAlertController(title: "Error", message:"App is not installed on this device", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
         self.present(alert, animated: true){}
        }
        */
    }
    
    @objc func edit() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
