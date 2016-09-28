//
//  SlideUpLauncher.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import Foundation
import UIKit

class SlideUpLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var _blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.whiteColor()
        return cv
    }()
    
    let cellId = "cellId"
    
    override init() {
        super.init()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        collectionView.registerClass(SlideUpCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, 50)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
        
        return cell
    }
    
    func showMenu() {
        if let window = UIApplication.sharedApplication().keyWindow {
            
            _blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            _blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
            
            window.addSubview(_blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = 200
            let y = window.frame.height - height
            collectionView.frame = CGRectMake(0, window.frame.height, window.frame.width, 200)
            _blackView.frame = window.frame
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
                self._blackView.alpha = 1
                self.collectionView.frame = CGRectMake(0, y, self.collectionView.frame.width, self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    func dismissMenu() {
        UIView.animateWithDuration(0.5) {
            self._blackView.alpha = 0
            
            if let window = UIApplication.sharedApplication().keyWindow {
                self.collectionView.frame = CGRectMake(0, window.frame.height, self.collectionView.frame.width, self.collectionView.frame.height)
            }
        }
    }
}