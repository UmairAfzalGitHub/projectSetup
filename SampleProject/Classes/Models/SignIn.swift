//
//  SignIn.swift
//  Labour Choice
//
//  Created by Umair on 22/06/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import ObjectMapper

class SignIn: Mappable {

    var id = ""
    var email = ""
    var imageURL = ""
    var isAccountVerified = false
    var mobileNumber = ""
    var firstName = ""
    var lastName = ""
    var gender = ""
    var genderType: Genders = .MALE
    var dob = ""
    var isStripeCustomer = false
    var userType = ""
    var city = ""
    var state = ""
    var postalCode = ""
    var streetAdress = ""

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id                  <- map["seeker._id"]
        isStripeCustomer    <- map["seeker.isStripeCustomer"]
        email               <- map["seeker.email"]
        dob                 <- map["seeker.dob"]
        imageURL            <- map["seeker.newProfileURL"]
        imageURL            <- map["seeker.profileImageUrl"]
        isAccountVerified   <- map["seeker.isAccountVerified"]
        mobileNumber        <- map["seeker.mobileNumber"]
        firstName           <- map["seeker.firstName"]
        lastName            <- map["seeker.lastName"]
        gender              <- map["seeker.gender"]
        userType            <- map["seeker.userType"]
        city                <- map["seeker.address.city"]
        state               <- map["seeker.address.state"]
        postalCode          <- map["seeker.address.postalCode"]
        streetAdress        <- map["seeker.address.streetAddress"]

        postMapping()
    }

    func postMapping() {

        if gender == "male" || gender == "MALE" || gender == "Male" {
            genderType = .MALE

        } else {
            genderType = .FEMALE
        }

        if isStripeCustomer {
            UserDefaults.standard.set(true, forKey: kIsCardInfoAdded)

        } else {
            UserDefaults.standard.removeObject(forKey: kIsCardInfoAdded)
        }
    }
}


class ProfileImage: Mappable {

    var imageUrl = ""

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        imageUrl                <- map["data.newProfileURL"]
    }
}
