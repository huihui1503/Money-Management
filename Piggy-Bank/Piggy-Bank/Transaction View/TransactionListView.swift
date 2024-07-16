//
//  TransactionListView.swift
//  Piggy-Bank
//
//  Created by Hui on 7/14/24.
//

import SwiftUI

struct TransactionListView: View {
    @Binding var currentDate: Date
    @State private var sampleData: [Transaction] = [
        .init(date: .init(), amount: 200, category: "Housing", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Food", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Beauty", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Housing", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Housing", note: "Renting"),
        .init(date: .init(), amount: 200, category: "Housing", note: "Renting")
    ]
    var body: some View {
        ForEach($sampleData) { $transaction in
            TransactionRowView(transaction: $transaction)
        }
    }
}
