//
//  ProfileTableViewCell.swift
//  CarsApp
//
//  Created by Mahsa Mirza on 11/25/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet var profile_label: UILabel!
    
    @IBOutlet var profile_image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
