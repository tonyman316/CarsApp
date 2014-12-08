//
//  SettingExtension.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/7/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import CoreData

extension Setting {
    class func databaseContainsSettings(context: NSManagedObjectContext) -> (isContained: Bool, settings: Setting?) {
        var result = false
        var settings: NSManagedObject?
        
        // Search for an existing Main User
        let request = NSFetchRequest(entityName: "Setting")
        var error = NSErrorPointer()
        let matches = context.executeFetchRequest(request, error: error)
        
        if matches!.isEmpty == false {
            settings = matches!.first as? NSManagedObject
            result = true
        }
        
        return (result, settings as? Setting)
    }
    
    class func creatDefaultSetting(unit: String, oilChangeFrequency: Int, transmissionFluidFrequency: Int, context: NSManagedObjectContext) {
        
        let newSetting = (NSEntityDescription .insertNewObjectForEntityForName("Setting", inManagedObjectContext: context)) as Setting
        
        newSetting.unit = unit
        newSetting.oilChangeFrequency = oilChangeFrequency
        newSetting.transmissionFluidFrequency = transmissionFluidFrequency
        
        var error = NSErrorPointer()
        println("New Setting created with unit: \(newSetting.unit), oilChangeFrequency: \(newSetting.oilChangeFrequency), transmissionFluidFrequency: \(newSetting.transmissionFluidFrequency)")
        context.save(error)
    }

}