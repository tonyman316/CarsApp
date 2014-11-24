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
    
    var carsImages = ["tesla.jpg", "hondaFit.jpg", "vwGolf.jpg", "bmw.jpg"]
    var owners = ["ABC", "DEF", "XXX", "ZZZ"]

    
    @IBOutlet var carsCollectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        carsCollectionView.contentInset = ({
            var contentInset = self.carsCollectionView.contentInset
            contentInset.top = 80
            return contentInset
        })()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width/2, height: self.view.frame.width/2)
        //layout.itemSize = CGSize(width: 185, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
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
        return carsImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CarsCell", forIndexPath: indexPath) as CarsCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.myCarsImageView.image = UIImage(named: carsImages[indexPath.row])
        cell.ownerLabel.text = owners[indexPath.row]
        
        return cell
    }
    
    
    


}
