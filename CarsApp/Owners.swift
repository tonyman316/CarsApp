//
//  Owners.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/3/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import CoreData

class Owners: NSManagedObject {

    @NSManaged var age: Int
    @NSManaged var firstName: String
    @NSManaged var isMainUser: NSNumber
    @NSManaged var lastName: String
    @NSManaged var password: String
    @NSManaged var picture: NSData
    @NSManaged var username: String
    @NSManaged var cars: NSSet

}
