//
//  OwnersExtension.swift
//  CarsApp
//
//  Created by Andrea Borghi on 11/29/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Owners {
    class func createUser(#userInfo: [String : String], userPicture: UIImage?, isMainUser: Bool, context: NSManagedObjectContext) {
        if isMainUser == true {
            let result = Owners.databaseContainsMainUser(context)
            
            if result.isContained == true {
                println("Deleting existing user \"\((result.user as Owners).firstName)\"")
                context.deleteObject(result.user!)
            }
        }
        
        let newUser = (NSEntityDescription .insertNewObjectForEntityForName("Owners", inManagedObjectContext: context)) as Owners
        
        // Create a new Main User
        newUser.firstName = userInfo["firstName"]!
        newUser.lastName = userInfo["lastName"]!
        
        if isMainUser == true {
            newUser.username = userInfo["username"]!
            newUser.password = userInfo["password"]!
            newUser.isMainUser = 1
        } else {
            newUser.isMainUser = false
        }
        
        if userPicture != nil {
            newUser.picture = UIImageJPEGRepresentation(userPicture!, 1.0)
        }
    }
    
    class func authenticateUser(#username: String, password: String, context: NSManagedObjectContext) -> Bool {
        var found = false
        
        let request = NSFetchRequest(entityName: "Owners")
        request.predicate = NSPredicate(format: "username = %@", username)
        var error = NSErrorPointer()
        let matches = context.executeFetchRequest(request, error: error)
        
        if matches?.isEmpty == false {
            if (matches?.first as Owners).password == password {
                found = true
            }
        }
        
        return found
    }
    
    class func databaseContainsMainUser(context: NSManagedObjectContext) -> (isContained: Bool, user: NSManagedObject?) {
        var result = false
        var user: NSManagedObject?
        
        // Search for an existing Main User
        let request = NSFetchRequest(entityName: "Owners")
        request.predicate = NSPredicate(format: "isMainUser = %d", 1)
        var error = NSErrorPointer()
        let matches = context.executeFetchRequest(request, error: error)
        
        if matches!.isEmpty == false {
            user = matches!.first as? NSManagedObject
            result = true
        }
        
        return (result, user)
    }
}