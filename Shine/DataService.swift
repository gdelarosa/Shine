//
//  DataService.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

// from google plist
let URL_DATABASE = FIRDatabase.database().reference()
let URL_STORAGE = FIRStorage.storage().reference()

class DataService {
    
    static let shared = DataService()
    
//MARK: Closures
    typealias COMPLETION_HANDLER = () -> ()
    typealias COMPLETION_HANDLER_IMAGE_UPLOAD = (imgUrl: String) -> ()
    typealias COMPLETION_HANDLER_IMAGE_FETCH = (img: UIImage) -> ()
    
//MARK: Image Cache
    private let imageCache = NSCache()
    
//MARK: Paths
    private var _REF_DATABASE = URL_DATABASE
    private var _REF_POSTS = URL_DATABASE.child("posts")
    private var _REF_USERS = URL_DATABASE.child("users")
    private var _REF_IMAGES = URL_STORAGE.child("images")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_DATABASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_IMAGES: FIRStorageReference {
        return _REF_IMAGES
    }

//MARK: User References
    
    private var _REF_USER: FIRDatabaseReference {
        guard let uid = NSUserDefaults.standardUserDefaults().objectForKey(KEY_UID) as? String else {
            return FIRDatabaseReference()
        }
        
        let currentUser = _REF_USERS.child(uid)
        return currentUser
    }
    
    var REF_USER_USERNAME: FIRDatabaseReference {
        return _REF_USER.child("username")
    }
    
    var REF_USER_PROFILE_IMAGE: FIRDatabaseReference {
        return _REF_USER.child("profileImage")
    }
    
    var REF_USER_POSTS: FIRDatabaseReference {
        return _REF_USER.child("posts")
    }
    
    var REF_USER_LIKES: FIRDatabaseReference {
        return _REF_USER.child("likes")
    }

//MARK: Methods
    
    func updateFirebaseUser(uid: String, user: Dictionary<String, AnyObject>) {
        
        _REF_USERS.child(uid).updateChildValues(user) { (error, reference) in
            if error != nil {
                print("Update user database failed \(error.debugDescription)")
                return
            }
            
            print("Updated user database")
        }
    }
    
    func getUserData(uid: String, completion: (user: User) -> ()) {
        
        _REF_USERS.child(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let userInfo = snapshot.value as? [String: AnyObject] {
                dispatch_async(dispatch_get_main_queue(), { 
                    completion(user: User(dictionary: userInfo))
                })
            }
        })
    }
    
    func createNewPost(postDescription: String, imgUrl: String?) -> [String: AnyObject] {
        
        var post: [String: AnyObject] = [
            "user": NSUserDefaults.standardUserDefaults().objectForKey(KEY_UID) as! String,
            "description": postDescription,
            "likes": 0
        ]
        
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        
        return post
    }
    
    func uploadPostToDatabase(post: [String: AnyObject], completion: COMPLETION_HANDLER) {
        
        // add /posts/post
        let newPost = DataService.shared.REF_POSTS.childByAutoId()
        newPost.setValue(post)
        
        // add users/uid/posts/key:bool
        DataService.shared.REF_USER_POSTS.child(newPost.key).setValue(true)
        
        completion()
    }
    
    func uploadImageToStorage(img: UIImage, completion: COMPLETION_HANDLER_IMAGE_UPLOAD) {
        
        let imgData = UIImageJPEGRepresentation(img, 0.2)! // convert image to data and compress (0.0 - 1.0)
        let imgPath = "\(NSDate.timeIntervalSinceReferenceDate())" // use current time to give unique name to image
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        
        // upload image to Firebase
        DataService.shared.REF_IMAGES.child(imgPath).putData(imgData, metadata: metadata, completion: { metadata, error in
            
            if error != nil {
                print("Error uploading image")
                return
            }
            
            guard let meta = metadata, let imgLink = meta.downloadURL()?.absoluteString else {
                return
            }
            
            print("Image uploaded successfully! Link: \(imgLink)")
            
            completion(imgUrl: imgLink)
        })
    }
    
    func updateProfileImageUrlInDatabase(imgUrl: String, completion: COMPLETION_HANDLER) {
        
        REF_USER_PROFILE_IMAGE.setValue(imgUrl) { (error, reference) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_UPDATED_PROFILE, object: nil)
                completion()
            })
        }
    }
    
    func fetchImage(imgUrl: String, completion: COMPLETION_HANDLER_IMAGE_FETCH) {
        
        if let cachedImage = imageCache.objectForKey(imgUrl) as? UIImage {
            // fetch from imageCache
            dispatch_async(dispatch_get_main_queue(), {
                completion(img: cachedImage)
            })
        }
        else {
            // download image
            Alamofire.request(.GET, imgUrl).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                guard let dt = data, let img = UIImage(data: dt) else {
                    return
                }
                
                self.imageCache.setObject(img, forKey: imgUrl) // save to cache
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion(img: img)
                })
            })
        }
    }
}