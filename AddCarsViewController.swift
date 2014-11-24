//
//  AddCarsViewController.swift
//  CarsApp
//
//  Created by Tony's Mac on 11/22/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class AddCarsViewController: UIViewController {

    @IBOutlet var addCarImageView: UIImageView!
    @IBOutlet var makeTextField: UITextField!
    @IBOutlet var modelTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var currentMileageTextField: UITextField!
    @IBOutlet var oilChangeTextField: UITextField!
    @IBOutlet var transmissionOilTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addCarImages(sender: AnyObject) {
        // Action Sheet
        
        
        // Camera
        
        
        // Camera Roll
        
        
        // Cancel
    }

    
    
    @IBAction func done(sender: UIBarButtonItem) {
        // Save to core data
        createCar()
        
        // Dismiss
        popToMainView()
    }
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Dismiss
        popToMainView()
    }
    
    
    func popToMainView() {
        navigationController?.popViewControllerAnimated(true)
    }
 
    // Save to Core Data
    func createCar() {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Cars", inManagedObjectContext: managedContext)
        
        var newCar = MyCars(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        newCar.make = makeTextField.text
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            
            println(newCar)

        }
}
        
//        newCar.model = modelTextField.text
//        newCar.year = yearTextField.text
//        newCar.price = priceTextField.text
//        newCar.currentMileage = currentMileageTextField.text
//        newCar.oilChange = oilChangeTextField.text
//        newCar.transOil = transmissionOilTextField.text

}
