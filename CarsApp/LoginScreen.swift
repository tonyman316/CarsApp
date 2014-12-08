//
//  LoginScreen.swift
//  CarsApp
//
//  Created by Andrea Borghi on 11/29/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices

class LoginScreen: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var choosePictureButton: UIButton!
    @IBOutlet weak var notYouLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var cameraUI:UIImagePickerController = UIImagePickerController()
    var userImage: UIImage?
    var activeField: UITextField?
    var hasUser = Owners.databaseContainsMainUser((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!).isContained
    var mainUser = Owners.databaseContainsMainUser((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!).user
    var newUserMode = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateEntranceWithRotation()
    }
    
    override func viewWillAppear(animated: Bool) {
        userImageView.hidden = true
        
        // Remove presenting view controller if not nil
        if presentingViewController != nil {
            presentingViewController!.removeFromParentViewController()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        
        var position = lastNameField.superview?.convertPoint(lastNameField.frame.origin, toView: nil)
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if hasUser && textField == passwordField {
            loginButtonPressed(self)
        }
        
        return true
    }
    
    func animateEntranceWithPop() {
        userImageView.transform = CGAffineTransformMakeScale(0, 0)
        usernameField.transform = CGAffineTransformMakeScale(0, 0)
        passwordField.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            self.userImageView.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            self.userImageView.transform = CGAffineTransformMakeScale(1, 1)
            self.usernameField.transform = CGAffineTransformMakeScale(1, 1)
            self.passwordField.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
    }
    
    func animateEntranceWithRotation() {
        let fullRotation = CGFloat(M_PI * 2)
        let originalCenter = userImageView.center
        
        userImageView.center = CGPointMake(userImageView.center.x + userImageView.frame.size.width + 20, userImageView.center.y)
        userImageView.hidden = false
        userImageView.transform = CGAffineTransformMakeRotation(fullRotation / 5 * 2)
        
        UIView.animateWithDuration(1.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            self.userImageView.transform = CGAffineTransformMakeRotation(fullRotation)
            self.userImageView.center = originalCenter
            }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.setupItemPictureLayer()
        scrollView.delegate = self
        
        if hasUser == true {
            firstNameField.hidden = true
            lastNameField.hidden = true
            choosePictureButton.hidden = true
            userImage = UIImage(data: mainUser!.picture)
        } else {
            notYouLabel.text = "Enter your details below!"
            signupButton.hidden = true
            loginButton.setTitle("Sign up", forState: UIControlState.Normal)
        }
        
        if let user = mainUser {
            usernameField.text = user.username
            userImageView.image = UIImage(data: user.picture)
        }
        
        usernameField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.scrollEnabled = false
        scrollView.contentSize = CGSizeMake(view.frame.width, view.frame.height + userImageView.frame.height)
        scrollView.bounds = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
    }
    
    @IBAction func choosePictureButtonPressed(sender: AnyObject) {
        showOptions()
    }
    
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
        var imageToSave: UIImage
        
        imageToSave = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        
        // Resize image doesn't work!!
        var newCGSize = CGSizeMake(100, 100)
        var resizeImage = RBResizeImage(imageToSave, targetSize: newCGSize) as UIImage
        userImage = imageToSave
        userImageView.image = imageToSave
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        
        if dataValidation() == false {
            let alert = UIAlertController(title: "Ooops!", message: "It seems like you are missing some details.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if hasUser == false || newUserMode == true {
            var userDictionary = [String : String]()
            userDictionary["firstName"] = firstNameField.text
            userDictionary["lastName"] = lastNameField.text
            userDictionary["username"] = usernameField.text
            userDictionary["password"] = passwordField.text
            
            Owners.createUser(userInfo: userDictionary, userPicture: userImage, isMainUser: true, context: context)
            (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
        }
        
        if Owners.authenticateUser(username: usernameField.text, password: passwordField.text, context: context) == true {
            newUserMode = false
            performSegueWithIdentifier("showMainScreen", sender: self)
        } else {
            let alert = UIAlertController(title: "Ooops!", message: "The user could not be authenticated. Plase try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        newUserMode = true
        animateSignUp()
    }
    
    func animateSignUp() {
        usernameField.text = ""
        passwordField.text = ""
        
        signupButton.hidden = true
        
        notYouLabel.hidden = false
        notYouLabel.text = "Enter your details below!"
        notYouLabel.alpha = 0.0
        
        firstNameField.hidden = false
        firstNameField.alpha = 0.0
        
        lastNameField.hidden = false
        lastNameField.alpha = 0.0
        
        choosePictureButton.hidden = false
        choosePictureButton.alpha = 0.0
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.notYouLabel.alpha = 1
            self.firstNameField.alpha = 1
            self.lastNameField.alpha = 1
            self.choosePictureButton.alpha = 1
            self.userImageView.image = UIImage(named: "defaultUserImage")
            self.loginButton.setTitle("Sign up", forState: UIControlState.Normal)
        })
    }
    
    func dataValidation() -> Bool {
        var result = true
        
        if hasUser == false || newUserMode == true {
            if usernameField.text.isEmpty || passwordField.text.isEmpty || firstNameField.text.isEmpty || lastNameField.text.isEmpty || userImage == nil {
                result = false
            }
        } else {
            if usernameField.text.isEmpty || passwordField.text.isEmpty {
                result = false
            }
        }
        
        return result
    }
}