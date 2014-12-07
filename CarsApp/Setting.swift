//
//  Setting.swift
//  CarsApp
//
//  Created by Tony's Mac on 12/5/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import CoreData

class Setting: NSManagedObject {

    @NSManaged var unit: String
    @NSManaged var oilChangeFrequency: NSNumber
    @NSManaged var transmissionFluidFrequency: NSNumber

}
