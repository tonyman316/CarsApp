//
//  UserCollectionViewCell.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/2/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import Foundation

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        setupItemPictureLayer()
    }
    
    func setupItemPictureLayer() {
        var layer = userImageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = self.userImageView.frame.width / 2
        layer.borderWidth = 4
        layer.borderColor = UIColor(red:(179.0/255.0), green:(179.0/255.0), blue:(179.0/255.0), alpha:(0.3)).CGColor
    }
}
