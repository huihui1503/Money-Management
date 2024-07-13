//
//  ContentView.swift
//  Piggy-Bank
//
//  Created by Hui on 7/9/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    enum TabType: Int32 {
        case transaction
        case statistic
        case setting
        
    }
    @State private var selectedTab: TabType = .transaction
    
    var body: some View {
        TabView(selection: $selectedTab, content: {
            TransactionView()
                .tabItem {
                    Label("Home", systemImage: "pencil.and.list.clipboard")
                }
                .tag(TabType.transaction)
            
            StatisticalView()
                .tabItem {
                    Label("Stats", systemImage: "chart.pie")
                }
                .tag(TabType.statistic)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(TabType.setting)
        })
        .tint(.coral)
        .onAppear(perform: {
            UITabBar.appearance().unselectedItemTintColor = .systemGray
            UITabBar.appearance().backgroundColor = .systemGray4.withAlphaComponent(0.4)
        })
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
