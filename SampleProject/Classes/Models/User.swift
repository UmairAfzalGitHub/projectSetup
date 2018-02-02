//
//  User.swift
//  Labour Choice
//
//  Created by Umair on 10/07/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import ObjectMapper

final class User {

    // Can't init is singleton
    private init() { }

    // MARK: Shared Instance

    static let shared = User()

    // MARK: Local Variable

    var id = ""
    var firstName = ""
    var lastName = ""
    var mobileNumber = ""
    var email = ""
    var profileImageURL = ""
    var dateOfBirth = ""
    var homeAddress = ""
    var city = ""
    var state = ""
    var postalCode = ""
    var deviceToken = "88CE02A9E00EDEA78BA516175703F296BDF862F53F160DD83DD74320F88298F2"
    var gender = "MALE"
    var badgeValue: Int = 0
    var isChatingWithId = ""
    
    //var categories = Mapper<VTCategories>().map(JSONObject: [:])!
    //var homeViewController = VTHomeViewController()
    
}
