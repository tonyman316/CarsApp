//
//  SelectUserProtocol.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/4/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation

protocol SelectUsersDelegate {
    func didSelectUsers(viewController: UsersCollectionViewController, selectedUsers users: [Owners]?)
}