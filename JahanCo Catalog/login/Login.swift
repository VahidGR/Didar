//
//  Login.swift
//  JahanCo Catalog
//
//  Created by Vahid Ghanbarpour on 7/27/17.
//  Copyright © 2017 Vahid Ghanbarpour. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class Login: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var usernameImage: UIImageView!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordImage: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPassword: UIButton!
        
    var arrRes = [[String:AnyObject]]() //Array of dictionary
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 0.1 * loginButton.bounds.size.width
        loginButton.layer.cornerRadius = 0.1 * loginButton.bounds.size.height
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
        usernameImage.image = UIImage(named: "logologin")
        passwordImage.image = UIImage(named: "logologin")
        self.title = "Login"
    }
	
	
	@objc func loginPressed() {
        let username = self.username.text
        let password = self.password.text
        UserDefaults.standard.set(String(describing: username), forKey: "username")
        UserDefaults.standard.set(String(describing: password), forKey: "password")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "Activation", sender: self)

        if username == "" || password == "" {
            let alert = UIAlertController(title: "Error", message:"Fill the fields first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
        } else {
            let loginURL = ""
            Alamofire.request(loginURL).validate().responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    print(response.result.value!)
                    let swiftyJsonVar = JSON(response.result.value!)
                    if let resData = swiftyJsonVar.arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    if self.arrRes.count > 0 {
                        UserDefaults.standard.set(String(describing: username), forKey: "username")
                        UserDefaults.standard.set(String(describing: password), forKey: "password")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "Activation", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Error", message:"Invalid username/password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                        self.present(alert, animated: true){}
                    }
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Error", message:"Invalid username/password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true){}
                }
            }
        }
    }
		
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
