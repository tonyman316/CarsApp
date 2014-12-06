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

class SettingTableViewController: UITableViewController {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

    var sectionNames = [String]()
    let identifier = "settingCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionNames.append("Units")
        sectionNames.append("Oil Change Frequency")

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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("headerCell") as UITableViewHeaderFooterView!

        var headerLabel = UILabel()
        headerLabel.tag = 999
        
        cell.contentView.addSubview(headerLabel)
        
        //headerLabel.text = "test"
        
//        lab.font = UIFont(name:"Georgia-Bold", size:22)
//        lab.textColor = UIColor.greenColor()
//        lab.backgroundColor = UIColor.clearColor()
//        h.contentView.addSubview(lab)
   
        return cell
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as SettingTableViewCell

        // Configure the cell...

        return cell
    }


}
