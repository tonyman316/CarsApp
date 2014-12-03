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

class MyCarsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    let identifier = "CarsCell"
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    @IBOutlet var carsCollectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Offset collection cell
        carsCollectionView.contentInset = ({
            var contentInset = self.carsCollectionView.contentInset
            contentInset.top = 80
            return contentInset
        })()
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        
        carsCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: self.view.frame.width/2-5, height: self.view.frame.width/2)
        layout.itemSize = CGSize(width: 180, height: 180)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 15
        
        carsCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        carsCollectionView!.dataSource = self
        carsCollectionView!.delegate = self
        carsCollectionView!.registerClass(CarsCVCell.self, forCellWithReuseIdentifier: identifier)
        carsCollectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(carsCollectionView!)
        
        //navigationController?.hidesBarsOnSwipe = true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width / 2.1, (collectionView.frame.height / 2) * 1/3)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.cornerRadius = 5.0
        cell.layer.shadowColor = UIColor.blueColor().CGColor;
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        cell.layer.shadowOpacity = 0.3
        
        // image frame design
        //        var carImageFrame:CGRect = cell.myCarsImageView.frame
        //        carImageFrame.size = CGSizeMake(180, 140)
        //        cell.myCarsImageView.frame = carImageFrame
        //        cell.myCarsImageView.clipsToBounds = true
        
        let car = fetchedResultController.objectAtIndexPath(indexPath) as MyCars
        cell.ownerLabel.text = car.make
        
        //cell.ownerLabel.text = car.valueForKey("make") as String?
        
        var imageFromModel: UIImage = UIImage(data: (car.valueForKey("carImage") as NSData))!
        cell.myCarsImageView.image = imageFromModel
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowCarDetail", sender: indexPath)
    }
    
    //Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowCarDetail") {
            let car = fetchedResultController.objectAtIndexPath(sender as NSIndexPath!) as MyCars
            
            let carDetailView = segue.destinationViewController as AddCarsViewController
            carDetailView.title = car.valueForKey("make") as String?
            carDetailView.car = car
        }
    }
}