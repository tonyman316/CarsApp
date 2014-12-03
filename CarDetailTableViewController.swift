//
//  CarDetailTableViewController.swift
//  CarsApp
//
//  Created by Tony's Mac on 11/22/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class CarDetailTableViewController: UITableViewController {
    
    var carList = [NSManagedObject]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return carList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CarDetailCell", forIndexPath: indexPath) as UITableViewCell
        
        let car = carList[indexPath.row]
        cell.textLabel!.text = car.valueForKey("make") as String?
        cell.detailTextLabel?.text = car.valueForKey("model") as String?
        var imageFromModel: UIImage = UIImage(data: (car.valueForKey("carImage") as NSData))!
        cell.imageView!.image = imageFromModel
        //cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
        if editingStyle == .Delete {
            
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context = appDelegate.managedObjectContext!
            
            // remove the deleted item from the model
            context.deleteObject(carList[indexPath.row] as NSManagedObject)
            carList.removeAtIndex(indexPath.row)
            context.save(nil)
            
            // remove the deleted item from the UITableView
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }

//            var error: NSError? = nil
//            if !context.save(&error){
//                abort()
//            }
        //tableView.reload()

    }
    
    func loadData() {
        // Fetching from Core Data
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Cars")
        
        //3
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            carList = results
        } else {
        println("Could not fetch \(error), \(error!.userInfo)")
        }
    }

}
