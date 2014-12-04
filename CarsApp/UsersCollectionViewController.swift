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
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(collectionView.frame.height/2, collectionView.frame.height/2)
//    }
    
    func animateCollectionViewAppearance() {
        UIView.animateWithDuration(1.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            self.collectionView!.contentOffset = CGPointMake(self.collectionView!.frame.size.width, 0)
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.backgroundColor = nil
        animateCollectionViewAppearance()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        users = Owners.getUsersInDatabase(inManagedObjectContext: managedObjectContext!)
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
        
        return cell
    }
}
