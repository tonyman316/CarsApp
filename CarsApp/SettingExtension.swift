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
}