//
//  CarsApp.swift
//  CarsApp
//
//  Created by Andrea Borghi on 11/29/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import CoreData

class Owners: NSManagedObject {
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var age: NSNumber
    @NSManaged var cars: MyCars
    @NSManaged var isMainUser: NSNumber
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var picture: NSData
}
