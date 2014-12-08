//
//  SelecCarProtocol.swift
//  CarsApp
//
//  Created by Mahsa Mirza on 12/7/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation

protocol SelectCarsDelegate {
    func didSelectCars(viewController: CarCollectionViewController, selectedCars cars: [MyCars]?)
}