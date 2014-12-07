//
//  SettingViewController.swift
//  CarsApp
//
//  Created by Tony's Mac on 12/6/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SettingViewController: UIViewController, NSFetchedResultsControllerDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    @IBOutlet var unitsLabel: UILabel!
    @IBOutlet var oilChangeLabel: UILabel!
    @IBOutlet var transmissionLabel: UILabel!
    
    @IBOutlet var unitsSwitchLabel: UISwitch!
    @IBOutlet var oilChangeSwitchLabel: UISwitch!
    @IBOutlet var transmissionSwitchLabel: UISwitch!
    
    var settingToSave: Setting? = nil
    //var settingFromDatabase: [Setting]?
    var settingFromDatabase: [AnyObject]?


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)

        if settingToSave == nil {
            createDefaultSetting()
        }else{
            fetchFromDatabase()
        }
        
        println("settingToSave: \(settingToSave?.unit)")
        println("settingFromDatabase: \(settingFromDatabase)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        if setting != nil {
//            unitsLabel.text = setting?.unit
//            if setting?.unit == "Miles" {
//                unitsSwitchLabel.setOn(true, animated: true)
//            }else{
//                unitsSwitchLabel.setOn(false, animated: true)
//            }
//        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Setting")
        let sortDescriptor = NSSortDescriptor(key: "unit", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    @IBAction func unitsSwitch(sender: AnyObject) {
        if unitsSwitchLabel.on {
            println("units Switch is on")
            
            //unitsLabel.text =
            
        }else{
            
            println("units Switch is off")

        }

    }

    @IBAction func oilChangeSwitch(sender: AnyObject) {
        if oilChangeSwitchLabel.on {
            
            println("oil Switch is on")
            //oilChangeLabel.text = "5000"
            
        }else{
            
            println("oil Switch is off")
            //oilChangeLabel.text = "8000"
            
        }
    }
    
    @IBAction func transmissionSwitch(sender: AnyObject) {
        if transmissionSwitchLabel.on {
            
            println("tran Switch is on")
            //transmissionLabel.text = "30000"
            
        }else{
            
            println("tran Switch is off")
            //transmissionLabel.text = "60000"
            
        }
    }
    
    // Save to Core Data
    func createDefaultSetting() {
        var newSetting: Setting
        
        if settingToSave == nil {
            let entityDescripition = NSEntityDescription.entityForName("Setting", inManagedObjectContext: managedObjectContext!)
            newSetting = Setting(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        }else{
            newSetting = settingToSave!
        }
        
        newSetting.unit = "Miles"
        //println(newSetting.unit)
        println(settingToSave)
        
//            if var oilChangeMiles = oilChangeLabel.text?.toInt() {
//                newDefaultSetting.oilChangeFrequency = oilChangeMiles
//                //println("oilChangeMiles: \(newDefaultSetting.oilChangeFrequency)")
//            }
//            
//            if var tranMiles = transmissionLabel.text?.toInt() {
//                newDefaultSetting.transmissionFluidFrequency = tranMiles
//                //println("tranMiles: \(newDefaultSetting.transmissionFluidFrequency)")
//            }

        managedObjectContext?.save(nil)
    }
    
//    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//    }
    
//    func fetchSetting() {
//        let fetchRequest = NSFetchRequest(entityName: "Setting")
//        let sortDescriptor = NSSortDescriptor(key: "unit", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as [Setting]? {
//            settingFromDatabase = fetchResults
//        }
//    }
    
    func fetchFromDatabase() {
        settingFromDatabase = fetchedResultController.fetchedObjects
        println(settingFromDatabase)
    }
    
    
}
