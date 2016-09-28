//
//  ProfileVC.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
//    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButton: UIButton! 
    
    var imagePicker = UIImagePickerController()
    var didAddNewProfileImage = false
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.enabled = false
        saveButton.backgroundColor = UIColor.grayColor()
        
        imagePicker.delegate = self
        
        usernameLabel.text = user.username
        
        setProfileImage()
    }
    
    func setProfileImage() {
        
        guard let imgUrl = user.profileImageUrl else {
            self.profileImage.image = UIImage(named: "camera")
            return
        }
        
        DataService.shared.fetchImage(imgUrl) { (img) in
            self.profileImage.image = img
        }
    }
    
    @IBAction func profileImagePressed(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: nil)
        
        profileImage.image = image
        didAddNewProfileImage = true
        saveButton.enabled = true
        saveButton.backgroundColor = THEME_BLUE
    }
    
    @IBAction func savePressed(sender: UIButton) {
        if didAddNewProfileImage == true, let img = profileImage.image {
            
            DataService.shared.uploadImageToStorage(img) { (imgUrl) in
                DataService.shared.updateProfileImageUrlInDatabase(imgUrl, completion: {
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
        }
    }
    
    @IBAction func logoutPressed(sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_UID)
            dismissViewControllerAnimated(true, completion: nil)
        }
        catch let error as NSError {
            print(error.debugDescription)
        }
    }
}
