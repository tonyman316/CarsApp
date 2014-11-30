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

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        profile_text_list = ["John Smith" , "Nearby Places" , "Photos"]
        profile_image_list = ["portrait_mode-50" , "gas_station-50" , "slr_small_lens-50"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return profile_text_list.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as ProfileTableViewCell
        
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle, reuseIdentifier: "ProfileCell")
//        }

        cell.profile_label.text = profile_text_list[indexPath.row]
        cell.profile_image.image = UIImage(named: profile_image_list[indexPath.row])
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
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
