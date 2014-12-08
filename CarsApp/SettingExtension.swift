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
        var settings: Setting?
        
        let request = NSFetchRequest(entityName: "Setting")
        var error = NSErrorPointer()
        let matches = context.executeFetchRequest(request, error: error)
        
        if matches!.isEmpty == false {
            settings = matches!.first as? Setting
            result = true
        } else {
            settings = createDefaultSetting("miles", oilChangeFrequency: 5000, transmissionFluidFrequency: 30000, context: context)
        }
        
        return (result, settings)
    }
    
    class func createDefaultSetting(unit: String, oilChangeFrequency: Int, transmissionFluidFrequency: Int, context: NSManagedObjectContext) -> Setting {
        let newSetting = (NSEntityDescription .insertNewObjectForEntityForName("Setting", inManagedObjectContext: context)) as Setting
        
        newSetting.unit = unit
        newSetting.oilChangeFrequency = oilChangeFrequency
        newSetting.transmissionFluidFrequency = transmissionFluidFrequency
        
        var error = NSErrorPointer()
        context.save(error)
        
        return newSetting
    }
}