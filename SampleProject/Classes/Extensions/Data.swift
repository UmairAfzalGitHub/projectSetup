//
//  Data.swift
//  PamperMoi
//
//  Created by Zeeshan@Vizteck on 18/04/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation

extension Data {
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    
}
