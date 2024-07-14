//
//  TransactionInteractor.swift
//  Piggy-Bank
//
//  Created by Hui on 7/14/24.
//

import SwiftUI

protocol DateHandlingProcotol {
    func initializeWeekSlider()
    func updateWeekSliders(from selectedDate: Date)
    func loadWeekSliderInAdvance(tabViewEdge: CGFloat)
}

class TransactionInteractor: ObservableObject {
    @Published var currentDate: Date = .init()
    @Published var weekSlider: [[Date.WeekDay]] = []
    @Published var selectedTabViewIndex: Int = 1
    @Published var selectedDate: Date = .init()
    @Published var shouldCreateWeek: Bool = false
    
    
}

extension TransactionInteractor: DateHandlingProcotol {
    func initializeWeekSlider() {
        if !weekSlider.isEmpty {
            weekSlider.removeAll()
        }
        weekSlider = [
            selectedDate.getAllDatesInPreviousWeek(),
            selectedDate.getAllDatesInWeek(),
            selectedDate.getAllDatesInNextWeek()
        ]
    }
    
    func loadWeekSliderInAdvance(tabViewEdge: CGFloat) {
        if tabViewEdge.rounded() == 15 && shouldCreateWeek {
            if weekSlider.indices.contains(selectedTabViewIndex) {
                if let firstDate = weekSlider[selectedTabViewIndex].first?.date {
                    if selectedTabViewIndex == 0 {
                        /// Inserting new week at oth index and remove the last array item
                        weekSlider.insert(firstDate.getAllDatesInPreviousWeek(), at: 0)
                        weekSlider.removeLast()
                        selectedTabViewIndex = 1
                    }
                    
                    if selectedTabViewIndex == (weekSlider.count - 1) {
                        /// Inserting new week at nth index and remove the first array item
                        weekSlider.append(firstDate.getAllDatesInNextWeek())
                        weekSlider.removeFirst()
                        selectedTabViewIndex = weekSlider.count - 2
                    }
                }
            }
        }
    }
    
    func updateWeekSliders(from selectedDate: Date) {
        weekSlider.removeAll()
        weekSlider.append(selectedDate.getAllDatesInPreviousWeek())
        weekSlider.append(selectedDate.getAllDatesInWeek())
        weekSlider.append(selectedDate.getAllDatesInNextWeek())
        shouldCreateWeek = false
    }
}
