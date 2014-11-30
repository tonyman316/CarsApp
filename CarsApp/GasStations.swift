//
//  GasStations.swift
//  CarsApp
//
//  Created by Andrea Borghi on 11/29/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class GasStations: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var address: String
    @NSManaged var distance: NSNumber

    var location: CLLocation {
        return CLLocation(latitude: latitude as Double, longitude: longitude as Double)
    }
}
