//
//  SlideUpCell.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

class SlideUpCell: BaseCell { // Add Flag inside of slide menu and create message. 
    
//    var flag: Flag? {
//        didSet {
//        nameLabel.text = flag?.name
//        
//        if let imageName = flag?.imageName {
//            iconImageView.image = UIImage(named: imageName)?.imageWithRendingModel(.AlwaysTemplate)
//            iconImageView.tintColor = UIColor.darkGrayColor()
//        }
//    }
//    
//}
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Flag"
        //label.font = UIFont.systemFontSize(13)
        return label
    }()
    
//    let iconImageView: UIImageView = {
//    let imageView = UIImageView()
//    imageView.image = UIImage(named: "Flag")
//    return imageView
//    }
//    
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        //addSubview(iconImageView)
        
       
        
//        addConstraint
    }
}