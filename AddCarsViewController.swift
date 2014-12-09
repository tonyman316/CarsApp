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

class AddCarsViewController: UIViewController, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, SelectUsersDelegate, UIScrollViewDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let currentSettings = (UIApplication.sharedApplication().delegate as AppDelegate).appSettings
    
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet var makeTextField: UITextField!
    @IBOutlet var modelTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var currentMileageTextField: UITextField!
    @IBOutlet var oilChangeTextField: UITextField!
    @IBOutlet var transmissionOilTextField: UITextField!
    @IBOutlet var containerView: UIView!
    
    var car: MyCars? = nil
    var carImage: UIImage?
    var users: [Owners]?
    var activeField: UITextField?
    var carPictureAlreadyAdded = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carButton.contentMode = UIViewContentMode.ScaleAspectFill
        carButton.clipsToBounds = true
        
        if car != nil {
            makeTextField.text = car?.make
            modelTextField.text = car?.model
            yearTextField.text = "\(car!.year)"
            
            if car?.price != 0 {
                priceTextField.text = car!.price.stringValue
            }
            
            if car?.currentMileage != 0 {
                if currentSettings.unit == "miles" {
                    currentMileageTextField.text = car!.currentMileage.stringValue
                } else {
                    currentMileageTextField.text = "\(floor(UnitConverter.milesToKilometers(car!.currentMileage.doubleValue)))"
                }
            }
            
            if car?.oilChange != 0 {
                if currentSettings.unit == "miles" {
                    oilChangeTextField.text = car!.oilChange.stringValue
                } else {
                    oilChangeTextField.text = "\(floor(UnitConverter.milesToKilometers(Double(car!.oilChange))))"
                }
            }
            
            if car?.transmissionOil != 0 {
                if currentSettings.unit == "miles" {
                    transmissionOilTextField.text = car!.transmissionOil.stringValue
                } else {
                    transmissionOilTextField.text = "\(floor(UnitConverter.milesToKilometers(Double(car!.transmissionOil))))"
                }
            }
            
            
            if car?.carImage != nil {
                carImage = UIImage(data: car!.carImage)
            }
        }
        
        scrollView.delegate = self
        makeTextField.delegate = self
        modelTextField.delegate = self
        yearTextField.delegate = self
        priceTextField.delegate = self
        currentMileageTextField.delegate = self
        oilChangeTextField.delegate = self
        transmissionOilTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //scrollView.scrollEnabled = false
        scrollView.contentSize = CGSizeMake(view.frame.width, scrollView.frame.height + makeTextField.frame.height + containerView.frame.height)
        scrollView.bounds = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        
        if let imageData = car?.valueForKey("carImage") as? NSData {
            if carPictureAlreadyAdded == false {
                addCarImageView(image: UIImage(data: imageData)!)
                carPictureAlreadyAdded = true
            }
        }
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue().size
        let buttonOrigin = activeField!.frame.origin
        let buttonHeight = activeField!.frame.size.height
        var visibleRect = view.frame
        
        var position = transmissionOilTextField.superview?.convertPoint(transmissionOilTextField.frame.origin, toView: nil)
        
        visibleRect.size.height -= keyboardSize.height
        
        if CGRectContainsPoint(visibleRect, buttonOrigin) == false {
            let scrollPoint = CGPointMake(0, buttonOrigin.y - visibleRect.size.height + buttonHeight)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        scrollView.setContentOffset(CGPointZero, animated: false)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
    
    // Dismiss keyboard when tap on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let option1 = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.presentCamera())})
            let option2 = UIAlertAction(title: "Choose Existing Photo", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.presentCameraRoll())})
            let option3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!) in ()})
            
            actionSheet.addAction(option1)
            actionSheet.addAction(option2)
            actionSheet.addAction(option3)
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        } else {
            presentCameraRoll()
        }
    }
    
    // MARK: Image Picker
    var cameraUI:UIImagePickerController = UIImagePickerController()
    
    func presentCamera() {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
        cameraUI.allowsEditing = false
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func presentCameraRoll() {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
        cameraUI.allowsEditing = false
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary) {
        var imageToSave:UIImage
        
        imageToSave = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        
        // Resize image doesn't work!!
        var newCGSize = CGSizeMake(100, 100)
        var resizeImage = RBResizeImage(imageToSave, targetSize: newCGSize) as UIImage
        
        addCarImageView(image: imageToSave)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addCarImageView(#image: UIImage) {
        carButton.setBackgroundImage(image, forState: UIControlState.Normal)
        carButton.setTitle("", forState: UIControlState.Normal)
        carImage = image
    }
    
    func popToMainView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // Save to Core Data
    func createCar() {
        var newCar: MyCars
        
        if car == nil {
            let entityDescripition = NSEntityDescription.entityForName("Cars", inManagedObjectContext: managedObjectContext!)
            newCar = MyCars(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        } else {
            newCar = car!
        }
        
        if carImage != nil {
            let imageData = UIImagePNGRepresentation(carImage!) as NSData
            newCar.carImage = imageData
        }
        
        newCar.make = makeTextField.text
        newCar.model = modelTextField.text
        
        if let year = yearTextField.text.toInt() {
            newCar.year = year
        }
        
        if !priceTextField.text.isEmpty && priceTextField.text != "" {
            newCar.price = priceTextField.text.toInt()!
        }
        
        if !currentMileageTextField.text.isEmpty && currentMileageTextField.text != "" {
            newCar.currentMileage = currentMileageTextField.text.toInt()!
        }
        
        if !oilChangeTextField.text.isEmpty && oilChangeTextField.text != "" {
            newCar.oilChange = oilChangeTextField.text.toInt()!
        }
        
        if !transmissionOilTextField.text.isEmpty && transmissionOilTextField.text != "" {
            newCar.transmissionOil = transmissionOilTextField.text.toInt()!
        }
        
        //oldCarInfo = newCar
        
        if users != nil && !(users!.isEmpty) {
            newCar.owners = users![0]
        } else if car == nil {
            newCar.owners = Owners.databaseContainsMainUser(managedObjectContext!).user!
            
            let userAlert = UIAlertController(title: "Owner not set", message: "Since you did not select a user, ownership of the car will be set to \(newCar.owners.firstName).", preferredStyle: UIAlertControllerStyle.Alert)
            userAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.dismissController()
            }))
            presentViewController(userAlert, animated: true, completion: nil)
        }
        
        managedObjectContext?.save(nil)
    }
    
    func dismissController() {
        navigationController!.popViewControllerAnimated(true)
    }
    
    func numberFromString(inputString: String) -> NSNumber? {
        let toNumber = inputString.toInt()
        return toNumber
    }
    
    func stringFromNumber(number: NSNumber) -> String? {
        let toString = "\(number)"
        return toString
    }
    
    // check input
    func validInput() -> Bool {
        if (carImage == nil || makeTextField.text.isEmpty || modelTextField.text.isEmpty || yearTextField.text.isEmpty){
            return false
        } else {
            return true
        }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedSegue" {
            var userCollectionView = segue.destinationViewController as UsersCollectionViewController
            
            if car != nil && car?.owners != nil {
                userCollectionView.selectedUsers = [car!.owners]
            }
            
            userCollectionView.del = self
            userCollectionView.clearsSelections = true
        }
    }
    
    func didSelectUsers(viewController: UsersCollectionViewController, selectedUsers users: [Owners]?) {
        self.users = users
    }
}