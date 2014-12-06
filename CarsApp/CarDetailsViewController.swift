//
//  CarDetailsViewController.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/5/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class CarDetailsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var coverLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oilChangeLabel: UILabel!
    
    @IBOutlet weak var mileageStepper: UIStepper!
    @IBOutlet weak var priceStepper: UIStepper!
    @IBOutlet weak var resetOilButton: UIButton!
    
    var car: MyCars? = nil
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
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
            
            mileageLabel.text = car!.currentMileage.stringValue + " miles"
            priceLabel.text = car!.price.stringValue + " dollars"
            
            if let oilChange = car?.oilChange.intValue {
                let milesSinceLastOilChange = car!.currentMileage.intValue - oilChange
                oilChangeLabel.text = "\(milesSinceLastOilChange) miles ago"
            }
        }
    }
    
    func setupSteppers() {
        mileageStepper.minimumValue = car!.currentMileage as Double
        mileageStepper.value = car!.currentMileage as Double
        mileageStepper.maximumValue = 200000
        mileageStepper.stepValue = 5
        
        priceStepper.minimumValue = 0
        priceStepper.value = car!.price as Double
        priceStepper.maximumValue = 500000
        priceStepper.stepValue = 50
    }

    @IBAction func stepperClicked(sender: AnyObject) {
        if sender as UIStepper == mileageStepper {
            mileageLabel.text = "\((sender as UIStepper).value) miles"
            
        } else if sender as UIStepper == priceStepper {
            priceLabel.text = "\((sender as UIStepper).value) dollars"
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        car?.currentMileage = mileageStepper.value
        car?.price = priceStepper.value
        
        let error = NSErrorPointer()
        managedObjectContext?.save(error)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
        setupSteppers()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editCar" {
            let editCarView = segue.destinationViewController as AddCarsViewController
            editCarView.title = "Edit \(car!.make) \(car!.model)"
            editCarView.car = car
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        if sender == resetOilButton {
            oilChangeLabel.text = "Just changed!"
            car?.oilChange = car!.currentMileage
        }
    }
}