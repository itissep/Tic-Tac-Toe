//
//  Date.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 04.05.2023.
//

import Foundation

extension Date {
    func timeToShow() -> String? {
        let format = self.isToday() ? "HH:mm" : "dd MMM"
        return self.dateAndTimetoString(format: format)
    }
    
    func dateAndTimetoString(format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func isEqual(to date: Date = Date(timeIntervalSinceNow: 0), toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    func isToday() -> Bool { isEqual(toGranularity: .day) }
}
