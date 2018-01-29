//
//  VTApiResponseHandler.swift
//  Labour Choice
//
//  Created by talha on 19/06/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import ObjectMapper

class VTResponseHandler: Mappable {

    // MARK: - Properties

    var status = false
    var success = false
    var message = ""
    var data: AnyObject? // data can be nil
    var error = ""
    var errorDescription: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        status              <- (map["response"], transform)
        success             <- map["success"]
        message             <- map["message"]
        data                <- map["data"]
        error               <- map["error"]
        errorDescription    <- map["error_description"]

    }

    // MARK: Transforms

    let transform = TransformOf<Bool, Int>(fromJSON: { (value: Int?) -> Bool? in

        if value == 200 {
            return true
        }

        return false

    }, toJSON: { (value: Bool?) -> Int? in

        if let value = value {

            if value == true {
                return 200
            }

            return 404
        }

        return 404
    })
}
