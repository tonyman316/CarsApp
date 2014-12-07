//
//  ProfileTableViewController.swift
//  CarsApp
//
//  Created by Mahsa Mirza on 11/25/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // @IBOutlet var profile_label: UILabel!
    
    var profile_text_list = [String]()
    var profile_image_list = [String]()
    
    var mainUser = Owners.databaseContainsMainUser((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!).user
    
    
    let identifier = "ProfileCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        profile_text_list = [user.firstname , user.lastname, ]
        profile_image_list = ["portrait_mode-50" , "gas_station-50" , "slr_small_lens-50"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profile_image_list.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerNib(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as ProfileTableViewCell
        
        if let user = mainUser {
            var age = String (user.age)
            profile_text_list = [user.firstName , user.lastName , age]
           // cell.profileLabel.text[2] = user.age
            
            cell.profileLabel.text = profile_text_list[indexPath.row]
            cell.profileImageView.image = UIImage(named: profile_image_list[indexPath.row])
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch (indexPath.row) {
        case 0: performSegueWithIdentifier("ShowMap", sender: self)
        break;
        case 1: performSegueWithIdentifier("ShowFriends", sender: self)
        break;
        default:
            break;
        }
        
        //        //var cell = tableView.cellForRowAtIndexPath(indexPath)
        //
        //        var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as ProfileTableViewCell
        //
        //        if cell.profile_label.text == profile_text_list[1] {
        //        performSegueWithIdentifier("ShowMap", sender: profile_text_list[1])
        //        }
        //       // tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    //
    //     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "ShowMap" {
    //
    //            var destViewController = segue.destinationViewController as MaptestViewController
    //            
    //        }
    //    }
    
    
}
