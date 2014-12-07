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
    
    @IBOutlet var unitSegmentControl: UISegmentedControl!
    @IBOutlet var oilChangeSegmentControl: UISegmentedControl!
    @IBOutlet var transmissionSegmentControl: UISegmentedControl!
    
    //var settingToSave: Setting? = nil
    var settingFromDatabase = Setting.databaseContainsSettings((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!).settings
    
    var userUnit = ""
    var userOilChange = 5000
    var userTransmission = 30000
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if settingFromDatabase == nil {
            createDefaultSetting()
        } else {
            //settingToSave = settingFromDatabase!
        }
        
        // Show correct Segment
        if settingFromDatabase?.unit == "miles" {
            unitSegmentControl.selectedSegmentIndex == 0
        }else{
            unitSegmentControl.selectedSegmentIndex == 1
        }
        
        if settingFromDatabase?.oilChangeFrequency == 5000 {
            oilChangeSegmentControl.selectedSegmentIndex = 0
        }else{
            oilChangeSegmentControl.selectedSegmentIndex = 1
        }
        
        if settingFromDatabase?.transmissionFluidFrequency == 30000 {
            transmissionSegmentControl.selectedSegmentIndex = 0
        }else{
            transmissionSegmentControl.selectedSegmentIndex = 1
        }
        
       // println("settingToSave: \(settingToSave?.unit)")
        println("settingFromDatabase: \(settingFromDatabase?.unit) \(settingFromDatabase?.oilChangeFrequency) \(settingFromDatabase?.transmissionFluidFrequency)")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save settings
        //updateSettingFromUser()

    }
    
    @IBAction func unitSegment(sender: AnyObject) {
        
        switch (unitSegmentControl.selectedSegmentIndex) {
        case 0: userUnit = "miles"
                oilChangeSegmentControl.setTitle("5000 miles", forSegmentAtIndex: 0)
                oilChangeSegmentControl.setTitle("8000 miles", forSegmentAtIndex: 1)
                transmissionSegmentControl.setTitle("30000 miles", forSegmentAtIndex: 0)
                transmissionSegmentControl.setTitle("60000 miles", forSegmentAtIndex: 1)
    
        case 1: userUnit = "km"
                oilChangeSegmentControl.setTitle("\(UnitConverter.milesToKilometers(5000)) km", forSegmentAtIndex: 0)
                oilChangeSegmentControl.setTitle("\(UnitConverter.milesToKilometers(8000)) km", forSegmentAtIndex: 1)
                transmissionSegmentControl.setTitle("\(UnitConverter.milesToKilometers(30000)) km", forSegmentAtIndex: 0)
                transmissionSegmentControl.setTitle("\(UnitConverter.milesToKilometers(60000)) km", forSegmentAtIndex: 1)

        default:
            break;
        }
    }

    @IBAction func oilChangeSegment(sender: AnyObject) {
        
        switch (unitSegmentControl.selectedSegmentIndex) {
        case 0: userOilChange = 5000
        case 1: userOilChange = 8000
            
        default:
            break;
        }

    }
    
    @IBAction func transmissionSegment(sender: AnyObject) {
        
        switch (unitSegmentControl.selectedSegmentIndex) {
        case 0: userTransmission = 30000
        case 1: userTransmission = 60000

        default:
            break;
        }

    }
    
    // Save to Core Data
    func createDefaultSetting() {
        var newSetting: Setting
        
        let entityDescripition = NSEntityDescription.entityForName("Setting", inManagedObjectContext: managedObjectContext!)
        newSetting = Setting(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        
        newSetting.unit = "miles"
        newSetting.oilChangeFrequency = 5000
        newSetting.transmissionFluidFrequency = 30000
        
//        if var oilChangeMiles = (oilChangeLabel.text? as NSString).doubleValue {
//            newDefaultSetting.oilChangeFrequency = oilChangeMiles
//            //println("oilChangeMiles: \(newDefaultSetting.oilChangeFrequency)")
//        }
//        
//        if var tranMiles = transmissionLabel.text?.toInt() {
//            newDefaultSetting.transmissionFluidFrequency = tranMiles
//            //println("tranMiles: \(newDefaultSetting.transmissionFluidFrequency)")
//        }
        
        managedObjectContext?.save(nil)
    }
    
    // Update to CoreData
    func updateSettingFromUser() {
        var userSetting: Setting
        
        let entityDescripition = NSEntityDescription.entityForName("Setting", inManagedObjectContext: managedObjectContext!)
        userSetting = Setting(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        
        userSetting.unit = userUnit
        userSetting.oilChangeFrequency = userOilChange
        userSetting.transmissionFluidFrequency = userTransmission
        
        managedObjectContext?.save(nil)


    }
}