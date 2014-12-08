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

class AddNewProfileViewController: UIViewController, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate ,/* SelectCarsDelegate */ UIScrollViewDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    @IBOutlet var addProfilePictureButton: UIButton!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var Password: UITextField!
    @IBOutlet var Age: UITextField!
    //@IBOutlet var profilePic: UIImageView!
    
    var user: Owners? = nil
    var profileImage: UIImage?
    var activeField: UITextField?
    var userPictureAlreadyAdded = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addProfilePictureButton.contentMode = UIViewContentMode.ScaleAspectFill
        addProfilePictureButton.clipsToBounds = true
        
        if user != nil {
            userName.text = user?.username
            firstNameTextField.text = user?.firstName
            lastNameTextField.text = user?.lastName
            //profilePic = UIImage(data: user!.picture)
            Age.text = "\(user!.age)"
            
            if user?.picture != nil {
                profileImage = UIImage(data: user!.picture)
            }
           }
            //scrollView.delegate = self
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
        
        //scrollView.scrollEnabled = false
       // scrollView.contentSize = CGSizeMake(view.frame.width, view.frame.height + makeTextField.frame.height * 6)
       // scrollView.bounds = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        
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
       // let buttonOrigin = activeField!.frame.origin
       // let buttonHeight = activeField!.frame.size.height
        var visibleRect = view.frame
        
        //var position = transmissionOilTextField.superview?.convertPoint(transmissionOilTextField.frame.origin, toView: nil)
        
        visibleRect.size.height -= keyboardSize.height
        
//        if CGRectContainsPoint(visibleRect, buttonOrigin) == false {
//            let scrollPoint = CGPointMake(0, buttonOrigin.y - visibleRect.size.height + buttonHeight)
//            scrollView.setContentOffset(scrollPoint, animated: true)
//        }
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

    
    
    @IBAction func addProfilePicture(sender: AnyObject) {
        // Action Sheet
        showOptions()
//        addProfilePictureButton.setBackgroundImage(image, forState: UIControlState.Normal)
//        addProfilePictureButton.setTitle("", forState: UIControlState.Normal)
//        profileImage = image
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
        var imageToSave = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        profileImage = imageToSave
        
        addProfilePictureButton.setBackgroundImage(imageToSave, forState: UIControlState.Normal)
        addProfilePictureButton.setTitle("", forState: UIControlState.Normal)
        addProfilePictureButton.imageView!.setupItemPictureLayer()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func addUserImageView(#image: UIImage) {
        addProfilePictureButton.setBackgroundImage(image, forState: UIControlState.Normal)
        addProfilePictureButton.setTitle("", forState: UIControlState.Normal)
        profileImage = image
    }
    
    
    func popToMainView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // Save to Core Data
//    func createProfile() {
//        var newUer: Owners
//        
//        if user == nil {
//            let
//        }
//        
//        
//        let imageData = UIImagePNGRepresentation(profileImage!) as NSData
//        var userDictionary = [String : String]()
//        userDictionary["firstName"] = firstNameTextField.text
//        userDictionary["lastName"] = lastNameTextField.text
//        //userDictionary["Age"] = Age.text
//        userDictionary["userName"] = userName.text
//        
//        Owners.createUser(userInfo: userDictionary, userPicture: profileImage, isMainUser: false, context: managedObjectContext!)
//        managedObjectContext?.save(nil)
//    }
//    
//    // check input
//    func validInput() -> Bool {
//        if (profileImage == nil || firstNameTextField.text.isEmpty || lastNameTextField.text.isEmpty){
//            return false
//        } else {
//            return true
//        }
//    }
//    
//}
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
        
//        if let year = yearTextField.text.toInt() {
//            newCar.year = year
//        }
//        
//        if users != nil && !(users!.isEmpty) {
//            newCar.owners = users![0]
//        } else if car == nil {
//            newCar.owners = Owners.databaseContainsMainUser(managedObjectContext!).user!
//            
//            let userAlert = UIAlertController(title: "Owner not set", message: "Since you did not select a user, ownership of the car will be set to \(newCar.owners.firstName).", preferredStyle: UIAlertControllerStyle.Alert)
//            userAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//                self.dismissController()
//            }))
//            presentViewController(userAlert, animated: true, completion: nil)
//        }
//        
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
        if (profileImage == nil){// || makeTextField.text.isEmpty || modelTextField.text.isEmpty || yearTextField.text.isEmpty /* || priceTextField.text.isEmpty || currentMileageTextField.text.isEmpty || oilChangeTextField.text.isEmpty || transmissionOilTextField.text.isEmpty */ ){
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
            
//            if user != nil && user?.Cars != nil {
//                userCollectionView.selectedUsers = [user!.Cars]
//            }
//            
           // userCollectionView.del = self
        }
    }
    
//    func didSelectUsers(viewController: UsersCollectionViewController, selectedUsers users: [Owners]?) {
//        self.users = users
//    }
}
