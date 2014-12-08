//
//  AddNewProfileViewController.swift
//  CarsApp
//
//  Created by Tony's Mac on 12/3/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import MobileCoreServices

class AddNewProfileViewController: UIViewController, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    @IBOutlet var addProfilePictureButton: UIButton!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var Password: UITextField!
    
    var user: Owners? = nil
    var profileImage: UIImage?
    var activeField: UITextField?
    var userPictureAlreadyAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var layer = addProfilePictureButton.layer
        layer.masksToBounds = true
        layer.cornerRadius = addProfilePictureButton.frame.width / 2
        layer.borderWidth = 4
        layer.borderColor = UIColor(red:(179.0/255.0), green:(179.0/255.0), blue:(179.0/255.0), alpha:(0.3)).CGColor
        
        addProfilePictureButton.contentMode = UIViewContentMode.ScaleAspectFill
        addProfilePictureButton.clipsToBounds = true
        
        if user != nil {
            userName.text = user?.username
            firstNameTextField.text = user?.firstName
            lastNameTextField.text = user?.lastName
            
            if user?.picture != nil {
                profileImage = UIImage(data: user!.picture)
            }
        }
        
        userName.delegate = self
        firstNameTextField.delegate = self
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
        
        if let imageData = user?.valueForKey("picture") as? NSData {
            if userPictureAlreadyAdded == false {
                addUserImageView(image: UIImage(data: imageData)!)
                userPictureAlreadyAdded = true
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
        var visibleRect = view.frame
        
        visibleRect.size.height -= keyboardSize.height
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        //scrollView.setContentOffset(CGPointZero, animated: false)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
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
    
    @IBAction func addProfilePicture(sender: AnyObject) {
        showOptions()
    }
    
    @IBAction func done(sender: AnyObject) {
        // check input validation
        if !validInput() {
            let alert = UIAlertController(title: "Oops!", message: "Make sure input All the information!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okButton)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            // Save to core data
            createProfile()
            // Dismiss
            popToMainView()
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
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
        var imageToSave = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        profileImage = imageToSave
        
        addUserImageView(image: imageToSave)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func addUserImageView(#image: UIImage) {
        addProfilePictureButton.setImage(image, forState: UIControlState.Normal)
        addProfilePictureButton.setTitle("", forState: UIControlState.Normal)
        profileImage = image
    }
    
    func popToMainView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func createProfile() {
        var newUser: Owners
        
        if user == nil {
            let entityDescripition = NSEntityDescription.entityForName("Owners", inManagedObjectContext: managedObjectContext!)
            newUser = Owners(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        } else {
            newUser = user!
        }
        
        if profileImage != nil {
            let imageData = UIImagePNGRepresentation(profileImage!) as NSData
            newUser.picture = imageData
        }
        
        newUser.firstName = firstNameTextField.text
        newUser.lastName = lastNameTextField.text
        newUser.username = userName.text
        newUser.password = Password.text
        
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
        if (profileImage == nil){
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
}
