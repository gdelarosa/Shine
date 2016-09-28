//
//  Post.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _postKey: String!
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _userId: String!
    private var _postRef: FIRDatabaseReference!
    
    var postKey: String {
        return _postKey
    }
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var userId: String {
        return _userId
    }
    
    init(postKey: String, dictionary: [String: AnyObject]) {
        _postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            _likes = likes
        }
        
        if let imgUrl = dictionary["imageUrl"] as? String {
            _imageUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            _postDescription = desc
        }
        
        if let userId = dictionary["user"] as? String {
            _userId = userId
        }
        
        _postRef = DataService.shared.REF_POSTS.child(postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        
        if addLike == true {
            _likes = _likes + 1
        }
        else {
            _likes = _likes - 1
        }
        
        _postRef.child("likes").setValue(_likes)
    }
}
