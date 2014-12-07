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
    
    var setting: Setting? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDefaultSetting()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unitsSwitch(sender: AnyObject) {
        if unitsSwitchLabel.on {
            
            println("units Switch is on")
            
            unitsLabel.text = "Miles"
            
        }else{
            
            println("units Switch is off")
            unitsLabel.text = "Km"

        }

    }

    @IBAction func oilChangeSwitch(sender: AnyObject) {
        if oilChangeSwitchLabel.on {
            
            println("oil Switch is on")
            oilChangeLabel.text = "5000"
            
        }else{
            
            println("oil Switch is off")
            oilChangeLabel.text = "8000"
            
        }
    }
    
    @IBAction func transmissionSwitch(sender: AnyObject) {
        if transmissionSwitchLabel.on {
            
            println("tran Switch is on")
            transmissionLabel.text = "30000"
            
        }else{
            
            println("tran Switch is off")
            transmissionLabel.text = "60000"
            
        }
    }
    
    // Save to Core Data
    func createDefaultSetting() {
        var newDefaultSetting: Setting
        
        if setting == nil {
            let entityDescripition = NSEntityDescription.entityForName("Setting", inManagedObjectContext: managedObjectContext!)
            newDefaultSetting = Setting(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
            
            newDefaultSetting.unit = unitsLabel.text!
            println(newDefaultSetting.unit)
        
            if let oilChangeMiles = oilChangeLabel.text?.toInt() {
                newDefaultSetting.oilChangeFrequency = oilChangeMiles
                println("oilChangeMiles\(oilChangeMiles)")
            }

        
            
//            var tranMiles = transmissionLabel.text?.toInt()
//            println(tranMiles)
//            newDefaultSetting.transmissionFluidFrequency = tranMiles!
            
            
        } else {
            newDefaultSetting = setting!
        }
        managedObjectContext?.save(nil)
        
    }

    
    
}
