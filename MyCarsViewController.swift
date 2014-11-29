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

class MyCarsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var carList = [NSManagedObject]()
    
    //var currentCars = [MyCars]()

    
    @IBOutlet var carsCollectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Offset collection cell
        carsCollectionView.contentInset = ({
            var contentInset = self.carsCollectionView.contentInset
            contentInset.top = 80
            return contentInset
        })()

        loadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width/2-5, height: self.view.frame.width/2)
        //layout.itemSize = CGSize(width: 185, height: 200)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 15
        carsCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        carsCollectionView!.dataSource = self
        carsCollectionView!.delegate = self
        carsCollectionView!.registerClass(CarsCollectionViewCell.self, forCellWithReuseIdentifier: "CarsCell")
        carsCollectionView!.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(carsCollectionView!)
        
        //navigationController?.hidesBarsOnSwipe = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CarsCell", forIndexPath: indexPath) as CarsCollectionViewCell
        
        // cell design(can change)
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.blueColor().CGColor;
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        cell.layer.shadowOpacity = 0.3
        
        let car: AnyObject = carList[indexPath.row]
        
        cell.ownerLabel.text = car.valueForKey("make") as String?

        var imageFromModel: UIImage = UIImage(data: (car.valueForKey("carImage") as NSData))!
        cell.myCarsImageView.image = imageFromModel
        
        var carImageFrame:CGRect = cell.myCarsImageView.frame
        carImageFrame.size = CGSizeMake(180, 140)
        cell.myCarsImageView.frame = carImageFrame
        //cell.myCarsImageView.clipsToBounds = true;

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowCarDetail", sender: carList[indexPath.row])
    }
    

     //Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ShowCarDetail") {
            var detailView = segue.destinationViewController as CarDetailViewController

//            let cell = sender as CarsCollectionViewCell
//            let indexPath = carsCollectionView.indexPathForCell(cell) as NSIndexPath?
//
//            var selectedItem = carList[indexPath!.row]
            
            //detailView.title = selectedItem.valueForKey("make") as String?
            
//            let car: AnyObject = carList[indexPath.row]
//            detailView.title = car.valueForKey("make") as String?

            

        }
//        }else if (segue.identifier == "AddCar"){
//            var addCarsView = segue.destinationViewController as AddCarsViewController
//        }
        
    }

    func loadData(){
        
        // Fetching from Core Data
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Cars")
        
        //3
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            carList = results
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        carsCollectionView.reloadData()
    }
    
}







