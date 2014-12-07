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
    
    @IBOutlet var unitsLabel: UILabel!
    @IBOutlet var oilChangeLabel: UILabel!
    @IBOutlet var transmissionLabel: UILabel!
    
    @IBOutlet var unitsSwitchLabel: UISwitch!
    @IBOutlet var oilChangeSwitchLabel: UISwitch!
    @IBOutlet var transmissionSwitchLabel: UISwitch!
    
    var settingToSave: Setting? = nil
    var settingFromDatabase = Setting.databaseContainsSettings((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!).settings
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if settingFromDatabase == nil {
            createDefaultSetting()
        } else {
            settingToSave = settingFromDatabase!
        }
        
        println("settingToSave: \(settingToSave?.unit)")
        println("settingFromDatabase: \(settingFromDatabase)")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save settings
    }
    
    @IBAction func unitsSwitch(sender: AnyObject) {
        if unitsSwitchLabel.on {
            println("units Switch is on")
            
            //unitsLabel.text =
            
        } else {
            println("units Switch is off")
        }
    }
    
    @IBAction func oilChangeSwitch(sender: AnyObject) {
        if oilChangeSwitchLabel.on {
            println("oil Switch is on")
            //oilChangeLabel.text = "5000"
        } else {
            println("oil Switch is off")
            //oilChangeLabel.text = "8000"
        }
    }
    
    @IBAction func transmissionSwitch(sender: AnyObject) {
        if transmissionSwitchLabel.on {
            println("tran Switch is on")
            //transmissionLabel.text = "30000"
        } else {
            println("tran Switch is off")
            //transmissionLabel.text = "60000"
        }
    }
    
    // Save to Core Data
    func createDefaultSetting() {
        var newSetting: Setting
        
        let entityDescripition = NSEntityDescription.entityForName("Setting", inManagedObjectContext: managedObjectContext!)
        newSetting = Setting(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        
        newSetting.unit = "Miles"
        //println(newSetting.unit)
        println(settingToSave)
        
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
}