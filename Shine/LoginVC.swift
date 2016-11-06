//
//  LoginVC.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: MaterialTextField!
    @IBOutlet weak var passwordTextField: MaterialTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // segues work after viewsDidAppear... Testing with this code. 
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)

//        if NSUserDefaults.standardUserDefaults().objectForKey(KEY_UID) != nil {
//            goToNextVC()
        }
    }
    
//    @IBAction func fbLoginPressed(sender: AnyObject) {
//       // AuthService.sharedInstance.fbLogin(self)
//    }
    
//    @IBAction func emailLoginPressed(sender: UIButton) {
    @IBAction func emailLoginPressed(_ sender: UIButton) {
    
    
        guard let email = emailTextField.text , email != "", let pass = passwordTextField.text , pass != "" else {
            
            let alert = AlertService.sharedInstance
            alert.showErrorAlert(self, title: alert.EMAIL_PASSWORD_REQUIRED_TITLE, msg: alert.EMAIL_PASSWORD_REQUIRED_MSG)
            return
        }
        
        AuthService.sharedInstance.emailLogin(self, email: email, pass: pass)
    }
    
    func goToNextVC() {
        DataService.shared.REF_USER_USERNAME.observeSingleEvent(of: .value, with: { snapshot in
            
            if (snapshot.value as? NSNull) != nil {
                self.performSegue(withIdentifier: SEGUE_CREATE_USERNAME, sender: nil)
            }
            else {
                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
            }
        })
    }

}
