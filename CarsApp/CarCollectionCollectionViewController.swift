//
//  CarCollectionCollectionViewController.swift
//  CarsApp
//
//  Created by Mahsa Mirza on 12/7/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//


import UIKit
import CoreData

class CarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout , NSFetchedResultsControllerDelegate {
    let reuseIdentifier = "customCell"
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var selectedCars: [MyCars]?
    var del: SelectCarsDelegate?
    let colorForBorder = UIColor(red:(179.0/255.0), green:(179.0/255.0), blue:(179.0/255.0), alpha:(0.3)).CGColor
    lazy var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    var specificUser: Owners?
    var userCars: [MyCars]?
    
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
        
        if specificUser == nil {
            fetchedResultController = getFetchedResultController()
            fetchedResultController.delegate = self
            fetchedResultController.performFetch(nil)
        } else {
            userCars = specificUser!.cars.allObjects as? [MyCars]
        }
        
        collectionView?.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if specificUser != nil {
            return specificUser!.cars.count
        }
        
        return fetchedResultController.fetchedObjects!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CarsCollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as CarsCollectionViewCell
        
        var car: MyCars
        
        if specificUser == nil {
            car = fetchedResultController.fetchedObjects![indexPath.row] as MyCars
        } else {
            car = userCars![indexPath.row]
        }
        
        cell.carImageView.image = UIImage(data: car.carImage)
        
        cell.nameLabel.text = car.make
        
        if selectedCars != nil {
            if contains(selectedCars!, car) == true {
                cell.carImageView.layer.borderColor = UIColor.blueColor().CGColor
            } else {
                cell.carImageView.layer.borderColor = colorForBorder
            }
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if parentViewController is ProfileViewController {
            var selected: MyCars
            
            if specificUser == nil {
                selected = fetchedResultController.fetchedObjects![indexPath.row] as MyCars
            } else {
                selected = userCars![indexPath.row]
            }
            
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as CarsCollectionViewCell
            
            if selectedCars != nil && contains(selectedCars!, selected) == true {
                selectedCars!.removeAtIndex(find(selectedCars!, selected)!)
            } else {
                if selectedCars == nil {
                    selectedCars = [MyCars]()
                }
                
                selectedCars!.append(selected)
            }
            
            del?.didSelectCars(self, selectedCars: selectedCars)
            selectedCars = nil
        }
    }
    
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Cars")
        let sortDescriptor = NSSortDescriptor(key: "make", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView!.reloadData()
    }
}