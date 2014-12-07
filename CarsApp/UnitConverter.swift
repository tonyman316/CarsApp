//
//  UnitConverter.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/7/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation

class UnitConverter {
    class func milesToKilometers(miles: Double) -> Double {
        return miles * 0.621371
    }
    
    class func kmToMiles(kilometers: Double) -> Double {
        return kilometers * 1.60934
    }
    
    class func gallonsToLiters(gallons: Double) -> Double {
        return gallons * 0.264172052
    }
    
    class func litersToGallons(liters: Double) -> Double {
        return liters * 3.78541178
    }
}