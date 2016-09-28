//
//  User.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    private var _email: String?
    private var _username: String?
    private var _profileImageUrl: String?
    
    var email: String? {
        return _email
    }
    
    var username: String? {
        return _username
    }
    
    var profileImageUrl: String? {
        return _profileImageUrl
    }
    
    init(dictionary: [String: AnyObject]) {
        
        if let email = dictionary["email"] as? String {
            _email = email
        }
        
        if let username = dictionary["username"] as? String {
            _username = username
        }
        
        if let profileImageUrl = dictionary["profileImage"] as? String {
            _profileImageUrl = profileImageUrl
        }
    }
}
