//
//  UIImageViewExtension.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/5/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

extension UIImageView {
    func setupItemPictureLayer() {
        var layer = self.layer
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.width / 2
        layer.borderWidth = 4
        layer.borderColor = UIColor(red:(179.0/255.0), green:(179.0/255.0), blue:(179.0/255.0), alpha:(0.3)).CGColor
    }
}