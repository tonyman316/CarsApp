//
//  OwnersExtension.swift
//  CarsApp
//
//  Created by Andrea Borghi on 11/29/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import CoreData

extension Owners {
    class func createMainUser(userInfo: [String : String], context: NSManagedObjectContext) {
        let result = Owners.databaseContainsMainUser(context)
        
        if result.isContained == true {
            println("Deleting existing user \"\((result.user as Owners).firstName)\"")
            context.deleteObject(result.user!)
        }
        
        // Create a new Main User
        let mainUser = (NSEntityDescription .insertNewObjectForEntityForName("Owners", inManagedObjectContext: context)) as Owners
        mainUser.firstName = userInfo["firstName"]!
        mainUser.lastName = userInfo["lastName"]!
        mainUser.username = userInfo["username"]!
        mainUser.password = userInfo["password"]!
        mainUser.isMainUser = 1
    }
    
    class func authenticateUser(username: String, password: String, context: NSManagedObjectContext) -> Bool {
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
            for user in matches! {
                println((user as Owners).firstName)
            }
            
            println("There is already a main user")
            user = matches!.first as? NSManagedObject
            result = true
        } else {
            println("A main user was not found")
        }
        
        return (result, user)
    }
}