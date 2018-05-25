//
//  Double.swift
//  PamperMoi
//
//  Created by Umair Afzal on 22/03/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation

extension Double {

    func timeStringFromUnixTime(dateFormatter: DateFormatter, deviderValue: Double = 1) -> String {
        let date = Date(timeIntervalSince1970: self/deviderValue)
        return dateFormatter.string(from: date)
    }
}
