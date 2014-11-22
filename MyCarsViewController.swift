//
//  MyCarsViewController.swift
//  CarsApp
//
//  Created by Tony's Mac on 11/21/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import Foundation

class MyCarsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    var carsImages = ["tesla.jpg", "hondaFit.jpg", "vwGolf.jpg", "bmw.jpg"]
    var owners = ["ABC", "DEF", "XXX", "ZZZ"]
    
    
    @IBOutlet var carsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width/2, height: self.view.frame.width/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        carsCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        carsCollectionView!.dataSource = self
        carsCollectionView!.delegate = self
        carsCollectionView!.registerClass(CarsCollectionViewCell.self, forCellWithReuseIdentifier: "CarsCell")
        carsCollectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(carsCollectionView!)
        
        navigationController?.hidesBarsOnSwipe = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carsImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CarsCell", forIndexPath: indexPath) as CarsCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        //cell.myCarsImageView?.image = UIImage(named: "tesla.jpg")
        //cell.ownerLabel.text = "Owner ABC"
        
        cell.myCarsImageView.image = UIImage(named: carsImages[indexPath.row])
        cell.ownerLabel.text = owners[indexPath.row]
        return cell
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
