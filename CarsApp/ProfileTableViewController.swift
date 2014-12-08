//
//  ProfileTableViewController.swift
//  CarsApp
//
//  Created by Mahsa Mirza on 11/25/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    var profile_text_list = [String]()
    var profile_image_list = [String]()
    var userToDisplay: Owners?
    let currentSettings = (UIApplication.sharedApplication().delegate as AppDelegate).appSettings
    let identifier = "ProfileCell"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        profile_image_list = ["portrait_mode-50" , "gas_station-50"]
        profile_text_list = [userToDisplay!.firstName + " " + userToDisplay!.lastName]
        
        if currentSettings.unit == "miles" {
            profile_text_list.append("\(floor(calculateUserTotalMileage())) total miles")
        } else {
            profile_text_list.append("\(floor(UnitConverter.milesToKilometers(calculateUserTotalMileage()))) total km")
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile_image_list.count
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as ProfileTableViewCell
        
            cell.profileLabel.text = profile_text_list[indexPath.row]
            cell.profileImageView.image = UIImage(named: profile_image_list[indexPath.row])
        
        return cell
    }
    
    func calculateUserTotalMileage() -> Double {
        var total = 0.0
        
        if let user = userToDisplay {
            if user.cars.count > 0 {
                for car in user.cars {
                    total += (car as MyCars).currentMileage.doubleValue
                }
            }
        }
        
        return total
    }
}