//
//  UsersCollectionViewController.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/2/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class UsersCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let reuseIdentifier = "customCell"
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var users: [Owners]?
    var selectedUsers: [Owners]?
    var del: SelectUsersDelegate?
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        var value = collectionView.frame.height - collectionView.layoutMargins.top * 3
    //        return CGSizeMake(value, value)
    //    }
    
    func animateCollectionViewAppearance() {
        UIView.animateWithDuration(1.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            self.collectionView!.contentOffset = CGPointMake(self.collectionView!.frame.size.width, 0)
            }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.alwaysBounceHorizontal = true
        collectionView!.backgroundColor = nil
        animateCollectionViewAppearance()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let array = users {
            return array.count
        }
        
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UserCollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UserCollectionViewCell
        cell.userImageView.image = UIImage(data: users![indexPath.row].picture)
        cell.nameLabel.text = users![indexPath.row].firstName
        
        let selected = users![indexPath.row]
        
        if selectedUsers != nil {
            if contains(selectedUsers!, selected) == true {
                cell.backgroundColor = UIColor.clearColor()
            } else {
                cell.backgroundColor = UIColor.blueColor()
            }
        }
        
        return cell
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        del?.didSelectUsers(self, selectedUsers: selectedUsers)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if parentViewController is AddCarsViewController {
            let selected = users![indexPath.row]
            
            if selectedUsers != nil && contains(selectedUsers!, selected) == true {
                collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.clearColor()
                selectedUsers!.removeAtIndex(find(selectedUsers!, selected)!)
            } else {
                if selectedUsers == nil {
                    selectedUsers = [Owners]()
                }
                
                collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.blueColor()
                selectedUsers!.append(selected)
            }
            
            del?.didSelectUsers(self, selectedUsers: selectedUsers)
        }
    }
}