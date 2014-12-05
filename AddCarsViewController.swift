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
    var users: [Owners]?
    var activeField: UITextField?
    var carPictureAlreadyAdded = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if car != nil {
            makeTextField.text = car?.make
            modelTextField.text = car?.model
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
        
        scrollView.scrollEnabled = false
        scrollView.contentSize = CGSizeMake(view.frame.width, view.frame.height + makeTextField.frame.height * 6)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss keyboard when tap on blank
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
        
        addCarImageView(image: imageToSave)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addCarImageView(#image: UIImage) {
        var newView = UIImageView(frame: carButton.frame)
        newView.image = image
        scrollView.addSubview(newView)
        carImage = image
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
        
        if users != nil {
            newCar.owners = users![0]
        }
        
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
        let imageData = UIImagePNGRepresentation(carImage!) as NSData
        car?.carImage = imageData
        car?.make = makeTextField.text
        car?.model = modelTextField.text
        
        if users != nil {
            println("The car will now have the folling users:")
            for user in users! {
                println("\(user.firstName)")
            }
            
            car?.owners = users![0]
        }
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedSegue" {
            var userCollectionView = segue.destinationViewController as UsersCollectionViewController
            
            if car != nil && car?.owners != nil {
                userCollectionView.selectedUsers = [car!.owners]
            }
            
            let usersInDatabase = Owners.getUsersInDatabase(inManagedObjectContext: managedObjectContext!)!
            userCollectionView.users = usersInDatabase
            
            userCollectionView.del = self
        }
    }
    
    func didSelectUsers(viewController: UsersCollectionViewController, selectedUsers users: [Owners]?) {
        self.users = users
        
        println("The selected users are:")
        
        if users != nil {
            for user in users! {
                println("\(user.firstName)")
            }
        }  else {
            println("None")
        }
    }
}