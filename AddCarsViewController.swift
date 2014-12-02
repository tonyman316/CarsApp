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

class AddCarsViewController: UIViewController, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet var makeTextField: UITextField!
    @IBOutlet var modelTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var currentMileageTextField: UITextField!
    @IBOutlet var oilChangeTextField: UITextField!
    @IBOutlet var transmissionOilTextField: UITextField!
    
    var car: MyCars? = nil
    var carImage: UIImage?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if car != nil {
            makeTextField.text = car?.make
            modelTextField.text = car?.model
            var imageFromModel: UIImage = UIImage(data: (car?.valueForKey("carImage") as NSData))!
            addCarImageView(image: imageFromModel)
        }
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
        // check input validation
        if !validInput() {
            
            let alert = UIAlertController(title: "Oops!", message: "Make sure input All the information!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okButton)
            
            self.presentViewController(alert, animated: true, completion: nil)

        } else if car != nil {
            editCar()
            
            // Dismiss
            popToMainView()
        } else {
            // Save to core data
            createCar()
            // Dismiss
            popToMainView()
        }
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
        let option3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!) in ()})
        
        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
        actionSheet.addAction(option3)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: Image Picker
    var cameraUI:UIImagePickerController = UIImagePickerController()
    
    func presentCamera() {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
        cameraUI.allowsEditing = true
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func presentCameraRoll() {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
        cameraUI.allowsEditing = true
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary) {
        var imageToSave:UIImage
        
        imageToSave = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        
        // Resize image doesn't work!!
        var newCGSize = CGSizeMake(100, 100)
        var resizeImage = RBResizeImage(imageToSave, targetSize: newCGSize) as UIImage
        carImage = imageToSave
        
        addCarImageView(image: carImage!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addCarImageView(#image: UIImage) {
        var newView = UIImageView(frame: carButton.frame)
        newView.image = image
        view.addSubview(newView)
    }
    
    func popToMainView() {
        navigationController?.popViewControllerAnimated(true)
    }
 
    // Save to Core Data
    func createCar() {
        let entityDescripition = NSEntityDescription.entityForName("Cars", inManagedObjectContext: managedObjectContext!)
        let newCar = MyCars(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        
        let imageData = UIImagePNGRepresentation(carImage!) as NSData
        newCar.carImage = imageData
        
        newCar.make = makeTextField.text
        newCar.model = modelTextField.text
        
//        newCar.year = yearTextField.text
//        newCar.price = priceTextField.text
//        newCar.currentMileage = currentMileageTextField.text
//        newCar.oilChange = oilChangeTextField.text
//        newCar.transOil = transmissionOilTextField.text
        
        managedObjectContext?.save(nil)
        
    }
    
    // check input
    func validInput() -> Bool {
        if (carImage == nil || makeTextField.text.isEmpty || modelTextField.text.isEmpty){
            return false
        } else {
            return true
        }
    }
    
    func editCar() {
        let imageData = UIImagePNGRepresentation(carButton.imageView?.image) as NSData
        car?.carImage = imageData
        car?.make = makeTextField.text
        car?.model = modelTextField.text
        managedObjectContext?.save(nil)
    }
    
    // Resize image func
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}