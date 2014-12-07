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

class SettingTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()


    var sectionNames = ["Units (Miles/Km)","Oil Change Frequency", "Transmission Fluid Change Frequency"]
    var defaultSetting = [AnyObject]()
    // oil: 5k/8k
    // fluid: 30k/60k
    let identifier = "settingCell"
    var setting: Setting? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName:"SettingTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        createDefaultSetting()
        
        defaultSetting = getDefaultSettingFromDatabase(inManagedObjectContext: managedObjectContext!)!
        println(defaultSetting)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        fetchedResultController = getFetchedResultController()
//        fetchedResultController.delegate = self
//        fetchedResultController.performFetch(nil)
        
        tableView.reloadData()
    }
    
//    func getFetchedResultController() -> NSFetchedResultsController {
//        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
//        return fetchedResultController
//    }
//    
//    func taskFetchRequest() -> NSFetchRequest {
//        let fetchRequest = NSFetchRequest(entityName: "Setting")
//        let sortDescriptor = NSSortDescriptor(key: "unit", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        return fetchRequest
//    }

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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        var name = ""
        
        switch(section){
            case 0: name = sectionNames[section]
            case 1: name = sectionNames[section]
            case 2: name = sectionNames[section]
            default: name = ""
        }
        
            return "\(name)"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as SettingTableViewCell
        
        var setting = [defaultSetting]
        var stringSetting = ""
        
        
        return cell
    }

    // Save to Core Data
    func createDefaultSetting() {
        var newDefaultSetting: Setting

        if setting == nil {
            let entityDescripition = NSEntityDescription.entityForName("Setting", inManagedObjectContext: managedObjectContext!)
            newDefaultSetting = Setting(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
            
            newDefaultSetting.unit = "Miles"
            newDefaultSetting.oilChangeFrequency = 5000
            newDefaultSetting.transmissionFluidFrequency = 30000
            
        } else {
            newDefaultSetting = setting!
            println(newDefaultSetting)
        }
        managedObjectContext?.save(nil)
        
    }
    
    
    func getDefaultSettingFromDatabase(inManagedObjectContext context: NSManagedObjectContext) -> [Setting]? {
        let request = NSFetchRequest(entityName: "Setting")
        var error = NSErrorPointer()
        let matches = context.executeFetchRequest(request, error: error)
        
        if matches?.isEmpty == false {
            return matches! as? [Setting]
        }
        
        return nil
    }
    
}
