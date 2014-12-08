//
//  CarDetailsViewController.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/5/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class CarDetailsViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var coverLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oilChangeLabel: UILabel!
    @IBOutlet weak var fluidChangeLabel: UILabel!
    
    @IBOutlet weak var mileageStepper: UIStepper!
    @IBOutlet weak var priceStepper: UIStepper!
    @IBOutlet weak var resetOilButton: UIButton!
    @IBOutlet weak var resetTransmissionButton: UIButton!
    
    var car: MyCars? = nil
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let tableHeaderHeight: CGFloat = 150
    var userImageHeight: CGFloat = 100
    var scrollViewOriginalHeight: CGFloat = 0.0
    var headerView: UIView!
    let currentSettings = (UIApplication.sharedApplication().delegate as AppDelegate).appSettings
    
    func updateHeaderView() {
        let originPoint = CGPointMake(coverImage.frame.origin.x, coverImage.frame.origin.y)
        
        var headerRect = CGRect(x: originPoint.x, y: originPoint.y, width: view.bounds.width, height: tableHeaderHeight - scrollView.contentOffset.y * 2)
        
        if headerRect.height > tableHeaderHeight && scrollView.contentOffset.y < tableHeaderHeight {
            coverImage.frame = headerRect
        } else {
            coverImage.frame = CGRect(origin: originPoint, size: CGSizeMake(view.bounds.width, tableHeaderHeight))
        }
    }
    
    func updateScrollView() {
        if scrollView.contentOffset.y < 0 && 1 + (scrollView.contentOffset.y / 100) > 0.4  {
            userImage.transform = CGAffineTransformMakeScale(1 + (scrollView.contentOffset.y / 100), 1 + (scrollView.contentOffset.y / 100))
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
        updateScrollView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        scrollView.delegate = self
        scrollViewOriginalHeight = scrollView.bounds.height
        userImageHeight = userImage.bounds.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSizeMake(view.frame.width, scrollView.frame.height * 1.1)
        var backgroundView = UIView(frame: CGRect(origin: CGPointMake(0, coverLabel.frame.height), size: scrollView.contentSize))
        backgroundView.backgroundColor = UIColor.whiteColor()
        scrollView.insertSubview(backgroundView, belowSubview: scrollView.subviews.first as UIView)
    }
    
    func refreshView() {
        if car != nil {
            coverImage.image = UIImage(data: car!.carImage)
            userImage.setupItemPictureLayer()
            
            if let userPic = car?.owners.picture {
                userImage.image = UIImage(data: userPic)
            }
            
            scrollView.bringSubviewToFront(userImage)
            
            coverLabel.text = "  " + car!.make + " " + car!.model + " (\(car!.year))"
            coverLabel.backgroundColor = coverLabel.backgroundColor?.colorWithAlphaComponent(0.8)
            
            if currentSettings.unit == "miles" {
                mileageLabel.text = car!.currentMileage.stringValue + " miles"
            } else {
                mileageLabel.text = "\(floor(UnitConverter.milesToKilometers(car!.currentMileage.doubleValue))) km"
            }
            
            priceLabel.text = car!.price.stringValue + " dollars"
            
            if let oilChange = car?.oilChange.intValue {
                let milesSinceLastOilChange = car!.currentMileage.intValue - oilChange
                
                if currentSettings.unit == "miles" {
                    oilChangeLabel.text = "\(milesSinceLastOilChange) miles ago"
                } else {
                    oilChangeLabel.text = "\(floor(UnitConverter.milesToKilometers(Double(milesSinceLastOilChange)))) km ago"
                }
                
            } else {
                oilChangeLabel.text = "Unavailable"
            }
            
            if let transmissionChange = car?.transmissionOil.intValue {
                let milesSinceLastTransmissionChange = car!.currentMileage.intValue - transmissionChange
                
                if currentSettings.unit == "miles" {
                    fluidChangeLabel.text = "\(milesSinceLastTransmissionChange) miles ago"
                } else {
                    fluidChangeLabel.text = "\(floor(UnitConverter.milesToKilometers(Double(milesSinceLastTransmissionChange)))) km ago"
                }
                
            } else {
                fluidChangeLabel.text = "Unavailable"
            }
        }
    }
    
    func setupSteppers() {
        mileageStepper.minimumValue = car!.currentMileage as Double
        mileageStepper.value = car!.currentMileage as Double
        priceStepper.value = car!.price as Double
    }
    
    @IBAction func stepperClicked(sender: AnyObject) {
        if sender as UIStepper == mileageStepper {
            mileageLabel.text = "\((sender as UIStepper).value) miles"
            
        } else if sender as UIStepper == priceStepper {
            priceLabel.text = "\((sender as UIStepper).value) dollars"
        }
    }
    
    func saveToCoreData() {
        car?.currentMileage = mileageStepper.value
        car?.price = priceStepper.value
        
        let error = NSErrorPointer()
        managedObjectContext?.save(error)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        saveToCoreData()
        setupNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
        setupSteppers()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editCar" {
            if (mileageStepper.value != car!.currentMileage || priceStepper.value != car!.price) {
                saveToCoreData()
            }
            
            let editCarView = segue.destinationViewController as AddCarsViewController
            editCarView.title = "Edit \(car!.make) \(car!.model)"
            editCarView.car = car
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        if sender == resetOilButton {
            oilChangeLabel.text = "Just changed!"
            car?.oilChange = car!.currentMileage
        } else if sender == resetTransmissionButton {
            fluidChangeLabel.text = "Just changed!"
            car?.transmissionOil = car!.currentMileage
        }
    }
    
    func setupNotifications() {
        var milesOrKm = currentSettings.unit
        
        var maxOilChangeFromUser = currentSettings.oilChangeFrequency.doubleValue
        var oilChangeText = oilChangeLabel.text! as NSString
        
        var maxFluidChangeFromUser = currentSettings.transmissionFluidFrequency.doubleValue
        var fluidChangeText = fluidChangeLabel.text! as NSString
        
        if oilChangeText.doubleValue >= maxOilChangeFromUser - 100 {
            var localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Oil change needed soon"
            
            if milesOrKm == "miles" {
                localNotification.alertBody = "Your \(car!.make) \(car!.model) currently has gone \(car!.oilChange) miles without an oil change. You should take care of that soon!"
            } else {
                localNotification.alertBody = "Your \(car!.make) \(car!.model) currently has gone \(UnitConverter.kmToMiles(car!.oilChange.doubleValue)) km without an oil change. You should take care of that soon!"
            }
            
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
            
            if find((UIApplication.sharedApplication().delegate as AppDelegate).userNotifications, localNotification) == nil {
                (UIApplication.sharedApplication().delegate as AppDelegate).userNotifications.append(localNotification)
            }
        }
        
        if fluidChangeText.doubleValue >= maxFluidChangeFromUser - 100 {
            var localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Transmission fluid change needed soon"
            
            if milesOrKm == "miles" {
                localNotification.alertBody = "Your \(car!.make) \(car!.model) currently has gone \(car!.transmissionOil) miles without a transmission oil change. You should take care of that soon!"
            } else {
                localNotification.alertBody = "Your \(car!.make) \(car!.model) currently has gone \(UnitConverter.kmToMiles(car!.transmissionOil.doubleValue)) km without an oil change. You should take care of that soon!"
            }
            
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
            
            if find((UIApplication.sharedApplication().delegate as AppDelegate).userNotifications, localNotification) == nil {
                (UIApplication.sharedApplication().delegate as AppDelegate).userNotifications.append(localNotification)
            }
        }
    }
}