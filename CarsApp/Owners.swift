//
//  Owners.swift
//  CarsApp
//
//  Created by Tony's Mac on 11/28/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import CoreData

class Owners: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var cars: MyCars

}
