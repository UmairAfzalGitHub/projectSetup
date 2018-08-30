//
//  Message.swift
//  Labour Choice
//
//  Created by Umair on 10/07/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import ObjectMapper

class Messages: Mappable {

    var messages = [Message]()
    var badgeValue: Int = 0

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        messages                <- map["messages"]
        badgeValue              <- map["unReadMessagesCount"]
    }
}

class Message : Mappable {

    var id = ""
    var createdAt = ""
    var updatedAt = ""
    var formattedDate = ""
    var body = ""
    var userId = ""
    var jobId = ""
    var threadId = ""
    var messageType = ""
    var seekerName = ""
    var isEdited = false
    var senderId = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id                      <- map["_id"]
        senderId                <- map["senderId"]
        createdAt               <- map["createdAt"]
        updatedAt               <- map["updatedAt"]
        formattedDate           <- map["formatedDate"]
        body                    <- map["body"]
        jobId                   <- map["jobId"]
        threadId                <- map["threadId"]
        messageType             <- map["messageType"]
        isEdited                <- map["isEdited"]
        seekerName              <- map["seeker.name"]
    }
}
