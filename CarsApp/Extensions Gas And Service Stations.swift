//
//  Extensions Gas And Service Stations.swift
//  CarsApp
//
//  Created by Andrea Borghi on 11/29/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import AddressBookUI

extension GasStations {
    class func populateDatabaseWithGasStations(userLocation: CLLocation, context: NSManagedObjectContext) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "gas station"
        let span = MKCoordinateSpanMake(0.1, 0.1)
        request.region = MKCoordinateRegionMake(userLocation.coordinate, span)
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse!, error: NSError!) -> Void in
            if (error == nil) {
                let locationsArray = response.mapItems as [MKMapItem]
                
                for location in locationsArray {
                    let name = location.name
                    let request = NSFetchRequest(entityName: "GasStations")
                    request.predicate = NSPredicate(format: "name = %@", name)
                    var error = NSErrorPointer()
                    let matches = context.executeFetchRequest(request, error: error)
                    
                    if (matches == nil) { // Check for errors?
                    } else if (matches?.count > 1) {
                    } else if (matches?.count == 1){
                    } else {
                        let gasStation = (NSEntityDescription .insertNewObjectForEntityForName("GasStations", inManagedObjectContext: context)) as GasStations
                        gasStation.name = name
                        let gasStationsPlacemark = location.placemark
                        gasStation.latitude = gasStationsPlacemark.location.coordinate.latitude
                        gasStation.longitude = gasStationsPlacemark.location.coordinate.longitude
                        let addressDictionary = gasStationsPlacemark.addressDictionary
                        gasStation.address = ABCreateStringWithAddressDictionary(addressDictionary, false)
                        gasStation.distance = GasStations.distanceBetweenUserAndLocation(gasStation.location) as NSNumber
                    }
                }
            }
        }
    }
    
    class func distanceBetweenUserAndLocation(location: CLLocation) -> CLLocationDistance {
        var currentLocation: CLLocation
        if CLLocationManager().location == nil {
            currentLocation = CLLocation(latitude: 37.332185, longitude: -122.030757)
        } else {
            currentLocation = CLLocationManager().location
        }
        return location.distanceFromLocation(currentLocation)/1000
    }
    
    class func isGasStation() -> Bool {
        return true
    }
}

extension ServiceStations {
    class func populateDatabaseWithServiceStations(userLocation: CLLocation, context: NSManagedObjectContext) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "mechanics"
        let span = MKCoordinateSpanMake(0.1, 0.1)
        request.region = MKCoordinateRegionMake(userLocation.coordinate, span)
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse!, error: NSError!) -> Void in
            if (error == nil) {
                let locationsArray = response.mapItems as [MKMapItem]
                
                for location in locationsArray {
                    let name = location.name
                    let request = NSFetchRequest(entityName: "ServiceStations")
                    request.predicate = NSPredicate(format: "name = %@", name)
                    var error = NSErrorPointer()
                    let matches = context.executeFetchRequest(request, error: error)
                    
                    if (matches == nil) { // Check for errors?
                    } else if (matches?.count > 1) {
                    } else if (matches?.count == 1){
                    } else {
                        let serviceStation = (NSEntityDescription .insertNewObjectForEntityForName("ServiceStations", inManagedObjectContext: context)) as ServiceStations
                        serviceStation.name = name
                        let serviceStationsPlacemark = location.placemark
                        serviceStation.latitude = serviceStationsPlacemark.location.coordinate.latitude
                        serviceStation.longitude = serviceStationsPlacemark.location.coordinate.longitude
                        let addressDictionary = serviceStationsPlacemark.addressDictionary
                        serviceStation.address = ABCreateStringWithAddressDictionary(addressDictionary, false)
                        serviceStation.distance = GasStations.distanceBetweenUserAndLocation(serviceStation.location) as NSNumber
                    }
                }
            }
        }
    }
    
    class func isServiceStation() -> Bool {
        return true
    }
}