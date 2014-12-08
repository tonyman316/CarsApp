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
    
    var setting: Setting? = nil
    var settingFromDatabase = Setting.databaseContainsSettings((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!).settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if settingFromDatabase == nil {
            println("No existing settings")
            createDefaultSetting()
        } else {
            println("Found existing settings")
            setting = settingFromDatabase!
            updateSegmentInterface()
        }
        
        unitSegmentControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        oilChangeSegmentControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        transmissionSegmentControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        println("settingFromDatabase: \(settingFromDatabase?.unit) \(settingFromDatabase?.oilChangeFrequency) \(settingFromDatabase?.transmissionFluidFrequency)")
        println("setting: \(setting?.unit) \(setting?.oilChangeFrequency) \(setting?.transmissionFluidFrequency)")

    }
    
    func segmentValueChanged(segment: UISegmentedControl) {
        if segment == unitSegmentControl {
            if (unitSegmentControl.selectedSegmentIndex == 0){
                setting?.unit = "miles"
            } else if (unitSegmentControl.selectedSegmentIndex == 1){
                setting?.unit = "km"
            }
            
        } else if segment == oilChangeSegmentControl {
            if (oilChangeSegmentControl.selectedSegmentIndex == 0){
                setting?.oilChangeFrequency = 5000
            } else if (oilChangeSegmentControl.selectedSegmentIndex == 1){
                setting?.oilChangeFrequency = 8000
            }
            
        } else if segment == transmissionSegmentControl {
            if (transmissionSegmentControl.selectedSegmentIndex == 0){
                setting?.oilChangeFrequency = 30000
            } else if (transmissionSegmentControl.selectedSegmentIndex == 1){
                setting?.oilChangeFrequency = 60000
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save settings
        managedObjectContext?.save(nil)
    }
    
    @IBAction func unitSegment(sender: AnyObject) {
        
        switch (unitSegmentControl.selectedSegmentIndex) {
        case 0: setting?.unit = "miles"
        oilChangeSegmentControl.setTitle("5000 miles", forSegmentAtIndex: 0)
        oilChangeSegmentControl.setTitle("8000 miles", forSegmentAtIndex: 1)
        transmissionSegmentControl.setTitle("30000 miles", forSegmentAtIndex: 0)
        transmissionSegmentControl.setTitle("60000 miles", forSegmentAtIndex: 1)
        println("UnitSegment 0, userUnit: \(setting?.unit)")
            
        case 1: setting?.unit = "km"
        oilChangeSegmentControl.setTitle("\(UnitConverter.milesToKilometers(5000)) km", forSegmentAtIndex: 0)
        oilChangeSegmentControl.setTitle("\(UnitConverter.milesToKilometers(8000)) km", forSegmentAtIndex: 1)
        transmissionSegmentControl.setTitle("\(UnitConverter.milesToKilometers(30000)) km", forSegmentAtIndex: 0)
        transmissionSegmentControl.setTitle("\(UnitConverter.milesToKilometers(60000)) km", forSegmentAtIndex: 1)
        println("UnitSegment 1, userUnit: \(setting?.unit)")
            
        default:
            break;
        }
    }
    
    @IBAction func oilChangeSegment(sender: AnyObject) {
        
        switch (oilChangeSegmentControl.selectedSegmentIndex) {
        case 0: setting?.oilChangeFrequency = 5000
                println("UnitSegment 0, userOilChange: \(setting?.oilChangeFrequency)")

        case 1: setting?.oilChangeFrequency = 8000
                println("UnitSegment 1, userOilChange: \(setting?.oilChangeFrequency)")
            
        default:
            break;
        }
    }
    
    @IBAction func transmissionSegment(sender: AnyObject) {
        
        switch (transmissionSegmentControl.selectedSegmentIndex) {
        case 0: setting?.transmissionFluidFrequency = 30000
                println("UnitSegment 0, userTran: \(setting?.transmissionFluidFrequency)")

        case 1: setting?.transmissionFluidFrequency = 60000
                println("UnitSegment 1, userTran: \(setting?.transmissionFluidFrequency)")

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
        
        managedObjectContext?.save(nil)
        
        setting = newSetting
        
        println("New settings created: \(newSetting)")
        
        updateSegmentInterface()
    }
    
    func updateSegmentInterface() {
        // Show correct Segments
        if setting?.unit == "miles" {
            unitSegmentControl.selectedSegmentIndex = 0
        } else {
            unitSegmentControl.selectedSegmentIndex = 1
            
            oilChangeSegmentControl.setTitle("\(UnitConverter.milesToKilometers(5000)) km", forSegmentAtIndex: 0)
            oilChangeSegmentControl.setTitle("\(UnitConverter.milesToKilometers(8000)) km", forSegmentAtIndex: 1)
            transmissionSegmentControl.setTitle("\(UnitConverter.milesToKilometers(30000)) km", forSegmentAtIndex: 0)
            transmissionSegmentControl.setTitle("\(UnitConverter.milesToKilometers(60000)) km", forSegmentAtIndex: 1)
        }
        
        if setting?.oilChangeFrequency == 5000 {
            oilChangeSegmentControl.selectedSegmentIndex = 0
        } else {
            oilChangeSegmentControl.selectedSegmentIndex = 1
        }
        
        if setting?.transmissionFluidFrequency == 30000 {
            transmissionSegmentControl.selectedSegmentIndex = 0
        } else {
            transmissionSegmentControl.selectedSegmentIndex = 1
        }
        
    }
    
}