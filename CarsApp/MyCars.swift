//
//  MyCars.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/3/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import CoreData

class MyCars: NSManagedObject {

    @NSManaged var carImage: NSData
    @NSManaged var make: String
    @NSManaged var model: String
    @NSManaged var owners: Owners

}
