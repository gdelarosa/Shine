//
//  LoginService.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static let sharedInstance = AuthService()
    
    // Status Codes https://www.firebase.com/docs/ios/guide/user-auth.html#section-full-error
    let STATUS_USER_NOT_FOUND = 17011
    let STATUS_INVALID_PASSWORD = 17009
    let STATUS_EMAIL_ALREADY_IN_USE = 17007
    
    let alert = AlertService.sharedInstance
    
    func emailLogin(vc: LoginVC, email: String, pass: String) {
        
        FIRAuth.auth()?.signInWithEmail(email, password: pass, completion: { (user, error) in
            
            if error == nil {
                // user already exists -> logged in successfully -> proceed to FeedVC
                NSUserDefaults.standardUserDefaults().setObject(user?.uid, forKey: KEY_UID)
                vc.goToNextVC()
            }
            else {
                // login failed -> check error
                guard let status = error?.code else {
                    return
                }
                
                if status == self.STATUS_INVALID_PASSWORD {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.alert.showErrorAlert(vc, title: self.alert.INVALID_PASSWORD_TITLE, msg: self.alert.INVALID_PASSWORD_MSG)
                    })
                    return
                }
                
                if status == self.STATUS_USER_NOT_FOUND {
                    FIRAuth.auth()?.createUserWithEmail(email, password: pass, completion: { (user, error) in
                        
                        if error != nil {
                            dispatch_async(dispatch_get_main_queue(), { 
                                self.alert.showErrorAlert(vc, title: self.alert.USER_NOT_FOUND_TITLE, msg: self.alert.USER_NOT_FOUND_MSG)
                            })
                            return
                        }
                        
                        guard let userId = user?.uid else {
                            return
                        }
                        
                        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: KEY_UID)
                        
                        FIRAuth.auth()?.signInWithEmail(email, password: pass, completion: { (user, error) in
                            let userData = [
                                "provider": "email",
                                "email": email
                            ]
                            DataService.shared.updateFirebaseUser(userId, user: userData)
                        })
                        
                        vc.goToNextVC()
                    })
                }
            }
        })
    }
}