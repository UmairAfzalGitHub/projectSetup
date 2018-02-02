//
//  StripeCustomer.swift
//  Help Connect
//
//  Created by Umair Afzal on 27/12/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import ObjectMapper

class StripeCustomer: Mappable {

    var id = ""
    var createdAt = ""
    var updatedAt = ""
    var customerId = ""
    var userId = ""
    var defaultSource = ""
    var cards = [CreditCards]()

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id                      <- map["customer._id"]
        createdAt               <- map["customer.createdAt"]
        updatedAt               <- map["customer.updatedAt"]
        customerId              <- map["customer.customerId"]
        userId                  <- map["customer.userId"]
        defaultSource           <- map["customer.default_source"]
        cards                   <- map["customer.cards"]

        postMapping()
    }

    func postMapping() {

        for card in cards {

            if defaultSource == card.cardId {
                card.isDefaultCard = true
            }
        }
    }
}

class CreditCards: Mappable {

    var cardId = ""
    var brand = ""
    var expMonth: Int = 0
    var expYear: Int = 2000
    var lastFour: Int = 0000
    var id  = ""
    var isDefaultCard = false

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        cardId                  <- map["cardId"]
        brand                   <- map["brand"]
        expMonth                <- map["expMonth"]
        expYear                 <- map["expYear"]
        lastFour                <- map["lastFour"]
        id                      <- map["_id"]
    }

}

class Job: Mappable {

    required init?(map: Map) {
    }

    func mapping(map: Map) {

    }
}
