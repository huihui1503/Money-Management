//
//  Transaction.swift
//  Piggy-Bank
//
//  Created by Hui on 7/14/24.
//

import Foundation

struct Transaction: Hashable, Identifiable {
    let id: UUID = .init()
    var date: Date
    var amount: Float
    var category: String
    var note: String
}

extension Transaction {
    static var sampleData: [Transaction] = [
        .init(date: .init(), amount: 200, category: "Housing", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Food", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Beauty", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Housing", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Housing", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Housing", note: "Renting")
    ]
}
