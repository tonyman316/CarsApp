//
//  ProfileViewController.swift
//  CarsApp
//
//  Created by Andrea Borghi on 11/30/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices
import CoreData

class ProfileViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate , UIActionSheetDelegate , SelectCarsDelegate {
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet var editButton: UIBarButtonItem!
    
    // @IBOutlet var editButton: UIButton!
    @IBOutlet var changePicture: UIButton!
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    ;
    var cameraUI:UIImagePickerController = UIImagePickerController()
    var userImage: UIImage?
    var mainUser = Owners.databaseContainsMainUser((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!).user
    var carToDisplay: MyCars?
    
    
    
    func didSelectCars(viewController: CarCollectionViewController, selectedCars cars: [MyCars]?) {
        carToDisplay = cars![0]
        performSegueWithIdentifier("carDetails", sender: carToDisplay)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let user = mainUser {
            userPicture.image = UIImage(data: user.picture)
            usernameLabel.text = user.firstName
        }
        
        PictureLayer(userPicture)
    }
    
    @IBAction func changePicturePressed(sender: AnyObject) {
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
        
        imageToSave = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        
    }
    
    
    
    
    //change profile picture
    func PictureLayer(picture:UIImageView) {
        var layer = picture.layer
        layer.masksToBounds = true
        layer.cornerRadius = picture.frame.width / 2
        layer.borderWidth = 4
        layer.borderColor = UIColor(red:(179.0/255.0), green:(179.0/255.0), blue:(179.0/255.0), alpha:(0.3)).CGColor
    }
    
    
    //    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary) {
    //        var imageToSave = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
    //        profileImage = imageToSave
    //
    //        addProfilePictureButton.setBackgroundImage(imageToSave, forState: UIControlState.Normal)
    //        addProfilePictureButton.setTitle("", forState: UIControlState.Normal)
    //
    //        self.dismissViewControllerAnimated(true, completion: nil)
    //    }
    
    func popToMainView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditUser" {
            let editUserView = segue.destinationViewController as AddNewProfileViewController
            editUserView.title = "Edit \(mainUser!.firstName)"
            editUserView.user = mainUser
        } else if segue.identifier == "carDetails" {
            let carView = segue.destinationViewController as CarDetailsViewController
            carView.title = "\(carToDisplay!.owners.firstName)'s \(carToDisplay!.make) \(carToDisplay!.model)"
            carView.car = carToDisplay
            
            println(carView.title)
        } else if segue.identifier == "embedSegue" {
            var carCollectionView = segue.destinationViewController as CarCollectionViewController
            carCollectionView.del = self
        }
    }
}