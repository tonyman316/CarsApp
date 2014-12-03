//
//  ProfileViewController.swift
//  CarsApp
//
//  Created by Andrea Borghi on 11/30/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}