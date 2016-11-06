//
//  TabBarVC.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/24/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController { // Will have to configure the user profile button. 
    
    let dataService = DataService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func profilePressed(_ sender: AnyObject) {
        
//        let currentUserId = NSUserDefaults.standardUserDefaults().objectForKey(KEY_UID) as! String
//        
//        dataService.getUserData(currentUserId) { (user) in
//            self.performSegueWithIdentifier(SEGUE_EDIT_PROFILE, sender: user)
//        }
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == SEGUE_EDIT_PROFILE, let profileVC = segue.destinationViewController as? ProfileVC, user = sender as? User {
//            profileVC.user = user
//        }
//    }
    

}
