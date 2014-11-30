//
//  CarDetailViewController.swift
//  CarsApp
//
//  Created by Tony's Mac on 11/22/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class CarDetailViewController: UIViewController {

    var carDetailImage: UIImage?
    var carDetailMake: String?
    
    @IBOutlet var carDetailImageView: UIImageView!
    @IBOutlet var makeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (carDetailMake != nil){
            makeLabel.text = carDetailMake
        }
        
        if (carDetailImage != nil){
            carDetailImageView.image = carDetailImage
        } else {
            carDetailImageView.image = UIImage(named: "Unknown.jpg")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
