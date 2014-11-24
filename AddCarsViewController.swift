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
import MobileCoreServices

class AddCarsViewController: UIViewController,UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate {

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
        showOptions()
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
    
    // Action Sheet
    func showOptions() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let option1 = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.presentCamera())})
        let option2 = UIAlertAction(title: "Choose Existing Photo", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.presentCameraRoll())})
        let option3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: {(actionSheet: UIAlertAction!) in ()})
        
        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
        actionSheet.addAction(option3)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: Image Picker
    var cameraUI:UIImagePickerController = UIImagePickerController()
    
    func presentCamera()
    {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
        cameraUI.allowsEditing = true
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func presentCameraRoll()
    {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
        cameraUI.allowsEditing = true
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary)
    {
        var imageToSave:UIImage
        
        imageToSave = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        self.dismissViewControllerAnimated(true, completion: nil)
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
