//
//  GasStationWithPrice.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/6/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import MapKit

class GasStationWithPrice: NSObject, MKAnnotation {
    var name: String
    var location: CLLocation
    var midGasPrice: Double
    var premiumGasPrice: Double
    var regularGasPrice: Double
    
    var title: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    
    init(responseDictionary: NSDictionary) {
        name = responseDictionary["address"] as NSString
        
        var lat = responseDictionary["lat"] as NSString
        var long = responseDictionary["lng"] as NSString
        location = CLLocation(latitude: lat.doubleValue, longitude:long.doubleValue)
        
        var midPrice = responseDictionary["mid_price"] as NSString
        if midPrice != "N/A" {
            midGasPrice = midPrice.doubleValue
        } else {
            midGasPrice = 0.0
        }
        
        var premiumPrice = responseDictionary["pre_price"] as NSString
        if premiumPrice != "N/A" {
            premiumGasPrice = premiumPrice.doubleValue
        } else {
            premiumGasPrice = 0.0
        }
        
        var regularPrice = responseDictionary["reg_price"] as NSString
        if regularPrice != "N/A" {
            regularGasPrice = regularPrice.doubleValue
        } else {
            regularGasPrice = 0.0
        }
        
        title = name
        
        var regular = "N/A"
        var mid = "N/A"
        var premium = "N/A"
        
        if regularGasPrice != 0 {
            regular = "$\(regularGasPrice)"
        }
        
        if midGasPrice != 0 {
            mid = "$\(midGasPrice)"
        }
        
        if premiumGasPrice != 0 {
            premium = "$\(premiumGasPrice)"
        }
        
        subtitle = "R: \(regular) - M: \(mid) - P: \(premium)"
        
        coordinate = location.coordinate
    }
}