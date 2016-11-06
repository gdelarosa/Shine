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
    
    func animateImageView(_ vc: FeedVC, statusImageView: UIImageView) {
        
        statusIV = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            
            blackBackgroundView.frame = vc.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            vc.view.addSubview(blackBackgroundView)
            
            if let keyWindow = UIApplication.shared.keyWindow {
                
                navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 64)
                navBarCoverView.backgroundColor = UIColor.black
                navBarCoverView.alpha = 0
                navBarCoverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                tabBarCoverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomedImageView.frame = startingFrame
            zoomedImageView.image = statusImageView.image
            zoomedImageView.contentMode = .scaleAspectFill
            zoomedImageView.clipsToBounds = false
            zoomedImageView.isUserInteractionEnabled = true
            zoomedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            vc.view.addSubview(zoomedImageView)
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.navBarCoverView.alpha = 1
                self.blackBackgroundView.alpha = 1
                self.tabBarCoverView.alpha = 1
                
                self.zoomedImageView.center = vc.view.center
                }, completion: nil)
        }
    }
    
    func zoomOut() {
        
        if let imageView = statusIV, let startingFrame = imageView.superview?.convert(imageView.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
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
