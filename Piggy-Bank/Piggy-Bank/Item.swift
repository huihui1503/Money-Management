//
//  Item.swift
//  Piggy-Bank
//
//  Created by Hui on 7/9/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
