//
//  CarsCollectionViewCell.swift
//  CarsApp
//
//  Created by Mahsa Mirza on 12/7/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import Foundation

class CarsCollectionViewCell: UICollectionViewCell {

        @IBOutlet weak var carImageView: UIImageView!
        @IBOutlet weak var nameLabel: UILabel!
        
        override func awakeFromNib() {
            carImageView.setupItemPictureLayer()
        }
 
}
