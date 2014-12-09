//
//  UsersCollectionViewController.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/2/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class UsersCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    let reuseIdentifier = "customCell"
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var selectedUsers: [Owners]?
    var del: SelectUsersDelegate?
    let colorForBorder = UIColor(red:(179.0/255.0), green:(179.0/255.0), blue:(179.0/255.0), alpha:(0.3)).CGColor
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    var clearsSelections = false
    
    func animateCollectionViewAppearance() {
        UIView.animateWithDuration(1.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            self.collectionView!.contentOffset = CGPointMake(self.collectionView!.frame.size.width, 0)
            }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.alwaysBounceHorizontal = true
        collectionView!.backgroundColor = nil
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        
        animateCollectionViewAppearance()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if clearsSelections == true && selectedUsers != nil {
            selectedUsers!.removeAll(keepCapacity: true)
        }
    }
    
    func usersDidChangeNotificationReceived() {
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultController.fetchedObjects!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UserCollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UserCollectionViewCell
        let user = fetchedResultController.fetchedObjects![indexPath.row] as Owners
        
        cell.userImageView.image = UIImage(data: user.picture)
        cell.nameLabel.text = user.firstName
        
        if selectedUsers != nil {
            if contains(selectedUsers!, user) == true {
                cell.userImageView.layer.borderColor = UIColor.blueColor().CGColor
            } else {
                cell.userImageView.layer.borderColor = colorForBorder
            }
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if parentViewController is AddCarsViewController || parentViewController is MyCarsViewController {
            let selected = fetchedResultController.fetchedObjects![indexPath.row] as Owners
            
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as UserCollectionViewCell
            
            if selectedUsers != nil && selectedUsers?.isEmpty == false && contains(selectedUsers!, selected) == true {
                cell.userImageView.layer.borderColor = colorForBorder
                selectedUsers!.removeAtIndex(find(selectedUsers!, selected)!)
            } else {
                if selectedUsers == nil {
                    selectedUsers = [Owners]()
                }
                
                if clearsSelections == false {
                    cell.userImageView.layer.borderColor = UIColor.blueColor().CGColor
                    selectedUsers!.append(selected)
                    
                } else if clearsSelections == true {
                    selectedUsers?.removeAll(keepCapacity: false)
                    selectedUsers?.append(selected)
                    collectionView.reloadData()
                }
            }
            
            del?.didSelectUsers(self, selectedUsers: selectedUsers)
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Owners")
        let sortDescriptor = NSSortDescriptor(key: "isMainUser", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView!.reloadData()
    }
}