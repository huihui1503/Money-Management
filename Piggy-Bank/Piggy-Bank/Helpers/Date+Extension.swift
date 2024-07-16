//
//  Date+Extension.swift
//  Piggy-Bank
//
//  Created by Hui on 7/9/24.
//

import Foundation

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func getAllDatesInWeek() -> [Date.WeekDay] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: self)?.start
        
        var weekDates: [Date.WeekDay] = []
        (0...6).forEach({ i in
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek!) {
                weekDates.append(.init(date: date))
            }
        })
        
        return weekDates
    }
    
    func getAllDatesInPreviousWeek() -> [Date.WeekDay] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
       
        guard let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: self)?.start,
              let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfWeek) else {
            return []
        }
        
        return previousDate.getAllDatesInWeek()
    }
    
    func getAllDatesInNextWeek() -> [Date.WeekDay] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
       
        guard let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: self)?.start,
              let nextDate = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            return []
        }
        
        return nextDate.getAllDatesInWeek()
    }
    
    
    func isTheSameDay(with date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    func isToday() -> Bool {
        let today = Date()
        return today.isTheSameDay(with: self)
    }
    
    struct WeekDay: Identifiable, Hashable {
        let id: UUID = .init()
        var date: Date
    }
}
