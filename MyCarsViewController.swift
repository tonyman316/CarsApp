//
//  MyCarsViewController.swift
//  CarsApp
//
//  Created by Tony's Mac on 11/21/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class MyCarsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, SelectUsersDelegate {
    let identifier = "CarsCell"
    var cars: [MyCars]?
    var users: [Owners]?
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    @IBOutlet var carsCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var value = collectionView.frame.size.width - 10
        return CGSizeMake(value, value * 2 / 3)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var headerView = carsCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "customHeader", forIndexPath: indexPath) as CustomHeader
        headerView.titleLabel.text = "Cars"
        return headerView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carsCollectionView!.dataSource = self
        carsCollectionView!.delegate = self
        carsCollectionView!.registerClass(CarsCVCell.self, forCellWithReuseIdentifier: identifier)
        carsCollectionView.clipsToBounds = false
        carsCollectionView!.backgroundColor = nil
        carsCollectionView!.alwaysBounceVertical = true
        
        animateCollectionViewAppearance()
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressHandler:");
        carsCollectionView.addGestureRecognizer(longPressGestureRecognizer)
        
        longPressGestureRecognizer.delegate = self
    }
    
    // Long press gesture handler
    func longPressHandler(sender:UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            var tapLocation: CGPoint = sender.locationInView(carsCollectionView)
            let indexPath = carsCollectionView.indexPathForItemAtPoint(tapLocation)
            
            if (indexPath != nil) {
                let car = fetchedResultController.objectAtIndexPath(indexPath!) as MyCars
                
                let alert = UIAlertController(title: nil, message: "Do you want to delete this car?", preferredStyle: UIAlertControllerStyle.Alert)
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (actionSheet: UIAlertAction!) -> Void in
                    self.deleteItem(indexPath!)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!) in (self.cancelDeletingCell(indexPath!))})
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                
                presentViewController(alert, animated: true, completion: nil)
            } else {
                cancelDeletingCell(indexPath!)
            }
        }
    }
    
    // Delete item in cell
    func deleteItem(indexOfCar: NSIndexPath) {
        let context = fetchedResultController.managedObjectContext
        context.deleteObject(fetchedResultController.objectAtIndexPath(indexOfCar) as NSManagedObject)
        context.save(nil)
    }
    
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
        carsCollectionView.reloadData()
    }
    
    // Cancel delete
    func cancelDeletingCell(indexPath: NSIndexPath) {
        //Get rid of highlight
        var cell = carsCollectionView.cellForItemAtIndexPath(indexPath) as CarsCVCell
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 2.5
    }
    
    func animateCollectionViewAppearance() {
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            self.carsCollectionView.contentOffset = CGPointMake(0, self.carsCollectionView.frame.size.height)
            }) { (finished: Bool) -> Void in
                if finished == true {
                    self.carsCollectionView.clipsToBounds = true
                }
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Cars")
        let sortDescriptor = NSSortDescriptor(key: "make", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    // CollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        collectionView.registerNib(UINib(nibName: "CarsCVCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as CarsCVCell
        
        // cell design(can change)
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderWidth = 2.5
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.cornerRadius = 5.0
        cell.layer.shadowColor = UIColor.blueColor().CGColor
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        cell.layer.shadowOpacity = 0.3
        
        let car = fetchedResultController.objectAtIndexPath(indexPath) as MyCars
        cell.ownerLabel.text = "\(car.make) \(car.model) (\(car.year))"
        
        //cell.ownerLabel.text = car.valueForKey("make") as String?
        var imageFromModel: UIImage = UIImage(data: (car.valueForKey("carImage") as NSData))!
        cell.myCarsImageView.image = imageFromModel
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowCarDetail", sender: indexPath)
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as CarsCVCell
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 2.5
    }
    
    //Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCarDetail" {
            let car = fetchedResultController.objectAtIndexPath(sender as NSIndexPath!) as MyCars
            
            let carDetailView = segue.destinationViewController as CarDetailsViewController
            
            carDetailView.title = "\(car.owners.firstName)'s \(car.make) \(car.model)"
            carDetailView.car = car
            
        } else if segue.identifier == "showProfile" {
            let profileView = segue.destinationViewController as ProfileViewController
            
            if users != nil && users?.isEmpty == false {
                profileView.userToDisplay = users?.first
            }
            
        } else if segue.identifier == "embedSegue" {
            var userCollectionView = segue.destinationViewController as UsersCollectionViewController
            userCollectionView.clearsSelections = true
            userCollectionView.del = self
        }
    }
    
    func didSelectUsers(viewController: UsersCollectionViewController, selectedUsers users: [Owners]?) {
        self.users = users
        performSegueWithIdentifier("showProfile", sender: self)
    }
}