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
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.gray
        
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
    
    @IBAction func profileImagePressed(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismiss(animated: true, completion: nil)
        
        profileImage.image = image
        didAddNewProfileImage = true
        saveButton.isEnabled = true
        saveButton.backgroundColor = THEME_BLUE
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        if didAddNewProfileImage == true, let img = profileImage.image {
            
            DataService.shared.uploadImageToStorage(img) { (imgUrl) in
                DataService.shared.updateProfileImageUrlInDatabase(imgUrl, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            
            UserDefaults.standard.removeObject(forKey: KEY_UID)
            dismiss(animated: true, completion: nil)
        }
        catch let error as NSError {
            print(error.debugDescription)
        }
    }
}
