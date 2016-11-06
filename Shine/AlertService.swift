//
//  AlertService.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit

class AlertService {
    
    static let sharedInstance = AlertService()
    
    fileprivate var _EMAIL_PASSWORD_REQUIRED_TITLE: String!
    fileprivate var _EMAIL_PASSWORD_REQUIRED_MSG: String!
    fileprivate var _EMAIL_ALREADY_IN_USE_TITLE: String!
    fileprivate var _EMAIL_ALREADY_IN_USE_MSG: String!
    fileprivate var _INVALID_PASSWORD_TITLE: String!
    fileprivate var _INVALID_PASSWORD_MSG: String!
    fileprivate var _USER_NOT_FOUND_TITLE: String!
    fileprivate var _USER_NOT_FOUND_MSG: String!
    
    var EMAIL_PASSWORD_REQUIRED_TITLE: String {
        return "Email & Password Required"
    }
    
    var EMAIL_PASSWORD_REQUIRED_MSG: String {
        return "You must enter an email and a password"
    }
    
    var EMAIL_ALREADY_IN_USE_TITLE: String {
        return "Could not sign up"
    }
    
    var EMAIL_ALREADY_IN_USE_MSG: String {
        return "Email is already in use. Try logging in with email and password"
    }
    
    var INVALID_PASSWORD_TITLE: String {
        return "Could not login"
    }
    
    var INVALID_PASSWORD_MSG: String {
        return "Check password or try logging in with Facebook"
    }
    
    var USER_NOT_FOUND_TITLE: String {
        return "Could not create account"
    }
    
    var USER_NOT_FOUND_MSG: String {
        return "Problem creating account. Try something else"
    }
    
    func showErrorAlert(_ vc: UIViewController, title: String, msg: String) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        vc.present(alertController, animated: true, completion: nil)
    }
}
