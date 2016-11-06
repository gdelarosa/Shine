//
//  FeedVC.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTextField: MaterialTextField!
    @IBOutlet weak var selectedImage: UIImageView!
    
    let dataService = DataService.shared
    
    
    var posts = [Post]()
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        tableView.estimatedRowHeight = 343
        tableView.rowHeight = UITableViewAutomaticDimension
        
        imagePicker.delegate = self
        
        setupObservers()
    }
    
    func setupObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: NSNotification.Name(rawValue: NOTIFICATION_UPDATED_PROFILE), object: nil)
        
        // listen to new events
        dataService.REF_POSTS.observe(.value, with: { snapshot in
            //            print(snapshot.value)
            
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    //                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> { // [String: AnyObject]
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.insert(post, at: 0)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else {
            return PostCell()
        }
        
        //        cell.request?.cancel()
        
        let post = posts[(indexPath as NSIndexPath).row]
        cell.feedVC = self
        cell.configureCell(post)
        cell.editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismiss(animated: true, completion: nil)
        selectedImage.image = image
    }
    
    @IBAction func cameraPressed(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
//    @IBAction func postPressed(sender: AnyObject) {
      @IBAction func postPressed(_ sender: AnyObject) {
        guard let postDescription = postTextField.text , postDescription != "" else {
            print("TEXTFIELD IS EMPTY")
            return
        }
        
        let cameraImage = UIImage(named:"camera")
        
        // add post without image
        guard let img = selectedImage.image , img != cameraImage else {
            let postWithoutImage = dataService.createNewPost(postDescription, imgUrl: nil)
            dataService.uploadPostToDatabase(postWithoutImage, completion: {
                self.refreshPostPanel()
            })
            return
        }
        
        // upload image, then add post with image
        dataService.uploadImageToStorage(img) { (imgUrl) in
            let postWithImage = self.dataService.createNewPost(postDescription, imgUrl: imgUrl)
            self.dataService.uploadPostToDatabase(postWithImage, completion: {
                self.refreshPostPanel()
            })
        }
    }
    
    func refreshPostPanel() {
        postTextField.text = ""
        selectedImage.image = UIImage(named: "camera")
        refreshTableView()
    }
    
//    @IBAction func profileButtonPressed(sender: UINavigationItem) {
//        
//        let currentUserId = NSUserDefaults.standardUserDefaults().objectForKey(KEY_UID) as! String
//        
//        dataService.getUserData(currentUserId) { (user) in
//            self.performSegueWithIdentifier(SEGUE_EDIT_PROFILE, sender: user)
//        }
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == SEGUE_EDIT_PROFILE, let profileVC = segue.destinationViewController as? ProfileVC, user = sender as? User {
//            profileVC.user = user
//        }
//    }
    
    func refreshTableView() {
        tableView.reloadData()
    }
    
    //TODO: work on slider
    let slideUpLauncher = SlideUpLauncher()
    
    func editButtonPressed() {
        slideUpLauncher.showMenu()
    }
}
