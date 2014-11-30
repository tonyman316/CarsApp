//
//  LoginScreen.swift
//  CarsApp
//
//  Created by Andrea Borghi on 11/29/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class LoginScreen: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var birthDateField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    var hasUser = Owners.databaseContainsMainUser((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!).isContained
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if hasUser == true {
            firstNameField.hidden = true
            lastNameField.hidden = true
            birthDateField.hidden = true
        }
        
        usernameField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        birthDateField.delegate = self
        
        registerForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillBeHidden:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue().size
        let buttonOrigin = activeField!.frame.origin
        let buttonHeight = activeField!.frame.size.height
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if !CGRectContainsPoint(visibleRect, buttonOrigin) {
            let scrollPoint = CGPointMake(0, buttonOrigin.y - visibleRect.size.height + buttonHeight)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if hasUser == true {
            performSegueWithIdentifier("showMainScreen", sender: self)
        } else {
            
        }
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        
        if hasUser == false {
            var userDictionary = [String : String]()
            userDictionary["firstName"] = firstNameField.text
            userDictionary["lastName"] = lastNameField.text
            userDictionary["username"] = usernameField.text
            userDictionary["password"] = passwordField.text
            userDictionary["birthday"] = birthDateField.text
            
            println("A new user was created")
            
            Owners.createMainUser(userDictionary, context: context)
            
            (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
        }
        
        if Owners.authenticateUser(usernameField.text, password: passwordField.text, context: context) == true {
            performSegueWithIdentifier("showMainScreen", sender: self)
        } else {
            let alert = UIAlertController(title: "Ooops!", message: "The user could not be authenticated. Plase try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
