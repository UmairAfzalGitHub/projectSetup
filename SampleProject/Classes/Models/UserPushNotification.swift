//
//  UserPushNotification.swift
//  Labour Choice
//
//  Created by Umair on 16/08/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import ObjectMapper

class UserPushNotitfication: Mappable {

    var alert = ""
    var body = ""
    var jobId = ""
    var type = ""
    var labourId = ""
    var senderName = ""
    var badgeValue = 0

    var senderId = ""
    var threadId = ""

    var lat: Double = 0.0
    var long: Double = 0.0
    var startTime = ""
    var address = ""
    var duration = ""
    var description = ""
    var test = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        alert           <- map["alert"]

        body            <- map["body"]
        jobId           <- map["jobId"]
        labourId        <- map["labourId"]
        senderName      <- map["senderName"]
        type            <- map["type"]
        threadId        <- map["threadId"]
        test            <- map["unReadMessagesCount"]

        lat             <- map["lat"]
        duration        <- map["duration"]
        long            <- map["long"]
        startTime       <- map["startTime"]
        address         <- map["title"]
        description     <- map["description"]

        if let x = Int(test) {
            badgeValue = x
        }
    }
}
