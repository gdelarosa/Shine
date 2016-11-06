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
    typealias COMPLETION_HANDLER_IMAGE_UPLOAD = (_ imgUrl: String) -> ()
    typealias COMPLETION_HANDLER_IMAGE_FETCH = (_ img: UIImage) -> ()
    
//MARK: Image Cache
    fileprivate let imageCache = NSCache()
    
//MARK: Paths
    fileprivate var _REF_DATABASE = URL_DATABASE
    fileprivate var _REF_POSTS = URL_DATABASE.child("posts")
    fileprivate var _REF_USERS = URL_DATABASE.child("users")
    fileprivate var _REF_IMAGES = URL_STORAGE.child("images")
    
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
    
    fileprivate var _REF_USER: FIRDatabaseReference {
        guard let uid = UserDefaults.standard.object(forKey: KEY_UID) as? String else {
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
    
    func updateFirebaseUser(_ uid: String, user: Dictionary<String, AnyObject>) {
        
        _REF_USERS.child(uid).updateChildValues(user) { (error, reference) in
            if error != nil {
                print("Update user database failed \(error.debugDescription)")
                return
            }
            
            print("Updated user database")
        }
    }
    
    func getUserData(_ uid: String, completion: @escaping (_ user: User) -> ()) {
        
        _REF_USERS.child(uid).observeSingleEvent(of: .value, with: { snapshot in
            
            if let userInfo = snapshot.value as? [String: AnyObject] {
                DispatchQueue.main.async(execute: { 
                    completion(User(dictionary: userInfo))
                })
            }
        })
    }
    
    func createNewPost(_ postDescription: String, imgUrl: String?) -> [String: AnyObject] {
        
        var post: [String: AnyObject] = [
            "user": UserDefaults.standard.object(forKey: KEY_UID) as! String as AnyObject,
            "description": postDescription as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        if imgUrl != nil {
            post["imageUrl"] = imgUrl! as AnyObject?
        }
        
        return post
    }
    
    func uploadPostToDatabase(_ post: [String: AnyObject], completion: COMPLETION_HANDLER) {
        
        // add /posts/post
        let newPost = DataService.shared.REF_POSTS.childByAutoId()
        newPost.setValue(post)
        
        // add users/uid/posts/key:bool
        DataService.shared.REF_USER_POSTS.child(newPost.key).setValue(true)
        
        completion()
    }
    
    func uploadImageToStorage(_ img: UIImage, completion: @escaping COMPLETION_HANDLER_IMAGE_UPLOAD) {
        
        let imgData = UIImageJPEGRepresentation(img, 0.2)! // convert image to data and compress (0.0 - 1.0)
        let imgPath = "\(Date.timeIntervalSinceReferenceDate)" // use current time to give unique name to image
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        
        // upload image to Firebase
        DataService.shared.REF_IMAGES.child(imgPath).put(imgData, metadata: metadata, completion: { metadata, error in
            
            if error != nil {
                print("Error uploading image")
                return
            }
            
            guard let meta = metadata, let imgLink = meta.downloadURL()?.absoluteString else {
                return
            }
            
            print("Image uploaded successfully! Link: \(imgLink)")
            
            completion(imgLink)
        })
    }
    
    func updateProfileImageUrlInDatabase(_ imgUrl: String, completion: @escaping COMPLETION_HANDLER) {
        
        REF_USER_PROFILE_IMAGE.setValue(imgUrl) { (error, reference) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_UPDATED_PROFILE), object: nil)
                completion()
            })
        }
    }
    
    func fetchImage(_ imgUrl: String, completion: @escaping COMPLETION_HANDLER_IMAGE_FETCH) {
        
        if let cachedImage = imageCache.object(forKey: imgUrl) as? UIImage {
            // fetch from imageCache
            DispatchQueue.main.async(execute: {
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
                
                DispatchQueue.main.async(execute: {
                    completion(img: img)
                })
            })
        }
    }
}
