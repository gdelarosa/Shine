 //
//  PostCell.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    fileprivate var _post: Post!
    fileprivate var _user: User!
    fileprivate var _likeRef: FIRDatabaseReference!
    //private var _request: Request?
    var feedVC: FeedVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateZoom)))
    }
    
    func animateZoom() {
        if let vc = feedVC {
            AnimationEngine.sharedInstance.animateImageView(vc, statusImageView: postImage)
        }
     }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        profileImage.image = nil
//        postImage.image = nil
    }
    
    func configureCell(_ post: Post) {
        _post = post
        
        descriptionText.text = post.postDescription
        
        if post.likes <= 0 {
            likesLabel.isHidden = true
        }
        else if post.likes == 1 {
            likesLabel.isHidden = false
            likesLabel.text = "\(post.likes) Like"
        }
        else {
            likesLabel.isHidden = false
            likesLabel.text = "\(post.likes) Likes"
        }
        
        DataService.shared.getUserData(post.userId) { (user) in
            self._user = user
            self.usernameLabel.text = user.username
            self.setProfileImage()
        }
        
        setPostImage()
        setLike()
    }
    
    func setProfileImage() {
        guard let imgUrl = _user.profileImageUrl else {
            self.profileImage.image = UIImage(named: "camera")
            return
        }
        
        DataService.shared.fetchImage(imgUrl) { (img) in
            self.profileImage.image = img
        }
    }
    
    func setPostImage() {
        guard let imgUrl = _post.imageUrl else {
            postImage.isHidden = true
            return
        }
        
        self.postImage.isHidden = false
        
        DataService.shared.fetchImage(imgUrl) { (img) in
            self.postImage.image = img
        }
    }
    
    func setLike() {
        // check if the likeRef exists for current user
        _likeRef = DataService.shared.REF_USER_LIKES.child(_post.postKey)
        
        _likeRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if (snapshot.value as? NSNull) != nil {
                self.likeButton.setTitleColor(UIColor.lightGray, for: UIControlState())
            }
            else {
                self.likeButton.setTitleColor(THEME_BLUE, for: UIControlState())
            }
        })
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        _likeRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if (snapshot.value as? NSNull) != nil {
                self.likeButton.setTitleColor(THEME_BLUE, for: UIControlState())
                self._post.adjustLikes(true)
                self._likeRef.setValue(true)
            }
            else {
                self.likeButton.setTitleColor(UIColor.lightGray, for: UIControlState())
                self._post.adjustLikes(false)
                self._likeRef.removeValue()
            }
        })
    }
}
