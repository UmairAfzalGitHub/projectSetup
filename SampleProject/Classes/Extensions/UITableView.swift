//
//  UITableView.swift
//  iosProjectAchitecture
//
//  Created by Umair Afzal on 21/05/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfRows(inSection:  self.numberOfSections-1), section:  self.numberOfSections-1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
