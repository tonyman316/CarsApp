//
//  SettingTableViewController.swift
//  CarsApp
//
//  Created by Tony's Mac on 12/5/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SettingTableViewController: UITableViewController, UISearchBarDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

    var sectionNames = ["Units","Oil Change Frequency", "Transmission Oil Change Frequency"]
    let identifier = "settingCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName:"SettingTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNames.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch(section){
//        case 0: title = "Units (Mile/Km)"
//        case 1: title = "Oil Change Freqency"
//        case 2: title = "Transmission Oil Change Frequency"
//        default: title = ""
//        }
//        return title
//    }
    
    func newLabelWithTitle(title: String) -> UILabel{
        let label = UILabel()
        label.text = title
        label.backgroundColor = UIColor.clearColor()
        label.sizeToFit()
        return label
    }
    
    func newViewForHeaderOrFooterWithText(text: String) -> UIView{
        let headerLabel = newLabelWithTitle(text)
        
        /* Move the label 10 points to the right */
        headerLabel.frame.origin.x += 10
        /* Go 5 points down in y axis */
        headerLabel.frame.origin.y = 5
        
        /* Give the container view 10 points more in width than our label
        because the label needs a 10 extra points left-margin */
        let resultFrame = CGRect(x: 0,
            y: 0,
            width: headerLabel.frame.size.width + 10,
            height: headerLabel.frame.size.height)
        
        let headerView = UIView(frame: resultFrame)
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("headerCell") as UITableViewHeaderFooterView
        if h.tintColor != UIColor.redColor() {
            println("configuring a new header view") // only called about 7 times
            h.backgroundView = UIView()
            h.backgroundView!.backgroundColor = UIColor.grayColor()
        }
        
        return newViewForHeaderOrFooterWithText("Section \(section) Header")
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String{
        var name = ""
        
//        switch(section){
//        case 0: sectionNames = "Units"
//        case 1: return sectionNames[1]
//        case 2: return sectionNames[2]
//        default: return ""
//        }
        
        for i in 0..< sectionNames.count {
            name = sectionNames[i]
        }

        
        return name
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as SettingTableViewCell

        // Configure the cell...

        return cell
    }


}
