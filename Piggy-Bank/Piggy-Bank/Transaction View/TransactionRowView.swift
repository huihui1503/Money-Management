//
//  TransactionRowView.swift
//  Piggy-Bank
//
//  Created by Hui on 7/14/24.
//

import SwiftUI

struct TransactionRowView: View {
    @Binding var transaction: Transaction
    var body: some View {
        HStack() {
            Text("Icon")
            VStack {
                Text("Mua gi")
                Text("The loai")
            }
            Text("Tieen")
        }
    }
}
