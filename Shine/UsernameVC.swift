//
//  UsernameVC.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit

class UsernameVC: UIViewController {

    @IBOutlet weak var usernameTextField: MaterialTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    @IBAction func donePressed(sender: AnyObject) {

    @IBAction func donePressed(_ sender: AnyObject) {
    
        guard let username = usernameTextField.text , username != "" else {
            AlertService.sharedInstance.showErrorAlert(self, title: "", msg: "") // TODO: add alert message
            return
        }
        
        DataService.shared.REF_USER_USERNAME.setValue(username)
        performSegue(withIdentifier: SEGUE_FINISHED_USERNAME, sender: nil)
    }

}
