//
//  AnimationEngine.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit

class AnimationEngine: NSObject {
    
    static let sharedInstance = AnimationEngine()
    
    var statusIV: UIImageView?
    let zoomedImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    func animateImageView(vc: FeedVC, statusImageView: UIImageView) {
        
        statusIV = statusImageView
        
        if let startingFrame = statusImageView.superview?.convertRect(statusImageView.frame, toView: nil) {
            
            statusImageView.alpha = 0
            
            blackBackgroundView.frame = vc.view.frame
            blackBackgroundView.backgroundColor = UIColor.blackColor()
            blackBackgroundView.alpha = 0
            blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            vc.view.addSubview(blackBackgroundView)
            
            if let keyWindow = UIApplication.sharedApplication().keyWindow {
                
                navBarCoverView.frame = CGRectMake(0, 0, 1000, 64)
                navBarCoverView.backgroundColor = UIColor.blackColor()
                navBarCoverView.alpha = 0
                navBarCoverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRectMake(0, keyWindow.frame.height - 49, 1000, 49)
                tabBarCoverView.backgroundColor = UIColor.blackColor()
                tabBarCoverView.alpha = 0
                tabBarCoverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomedImageView.frame = startingFrame
            zoomedImageView.image = statusImageView.image
            zoomedImageView.contentMode = .ScaleAspectFill
            zoomedImageView.clipsToBounds = false
            zoomedImageView.userInteractionEnabled = true
            zoomedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            vc.view.addSubview(zoomedImageView)
            
            UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
                self.navBarCoverView.alpha = 1
                self.blackBackgroundView.alpha = 1
                self.tabBarCoverView.alpha = 1
                
                self.zoomedImageView.center = vc.view.center
                }, completion: nil)
        }
    }
    
    func zoomOut() {
        
        if let imageView = statusIV, startingFrame = imageView.superview?.convertRect(imageView.frame, toView: nil) {
            
            UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
                
                self.navBarCoverView.alpha = 0
                self.blackBackgroundView.alpha = 0
                self.tabBarCoverView.alpha = 0
                self.zoomedImageView.frame = startingFrame
                self.zoomedImageView.clipsToBounds = true
                
                }, completion: { (success) in
                    
                    self.navBarCoverView.removeFromSuperview()
                    self.blackBackgroundView.removeFromSuperview()
                    self.tabBarCoverView.removeFromSuperview()
                    self.zoomedImageView.removeFromSuperview()
                    imageView.alpha = 1
            })
        }
    }
}