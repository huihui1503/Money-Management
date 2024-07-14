//
//  OffsetKey.swift
//  Piggy-Bank
//
//  Created by Hui on 7/14/24.
//

import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey {
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
    static var defaultValue: CGFloat = 0
}
