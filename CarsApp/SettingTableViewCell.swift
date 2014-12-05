//
//  SettingTableViewCell.swift
//  CarsApp
//
//  Created by Tony's Mac on 12/5/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet var settingLabel: UILabel!
    @IBOutlet var SettingSwitchLabel: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func settingSwitch(sender: AnyObject) {
        if SettingSwitchLabel.on {
            
            println("Switch is on")
            
        }else{
            
            println("Switch is off")

        }
    }
}
