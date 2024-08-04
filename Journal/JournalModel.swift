//
//  JournalModel.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/25.
//

import Foundation
import SwiftData

@Model
class log {
    
    var logDate: Date
    var stressLevel: Double
    
    init (logDate: Date, stressLevel: Double) {
        self.logDate = logDate
        self.stressLevel = stressLevel
    }
}

extension log {
    static func getStressAvg (dayStressLogs: [log]) -> Double {
        let dayStressAvg = dayStressLogs.reduce(0.00) {$0 + $1.stressLevel} / Double(dayStressLogs.count)
        return dayStressAvg
    }
    
    static func dayLog(date: Date) -> Predicate<log> {
        
        let endDate = Calendar.current.startOfDay(for: date.addingTimeInterval(86400))
        let startDate = Calendar.current.startOfDay(for: date)

        return #Predicate<log> { log in
            startDate < log.logDate &&
            log.logDate < endDate
        }
    }
    
    static func thisWeeksLogs() -> Predicate<log> {
        
        let date = Date()
        let weekAgo = date.addingTimeInterval(-86400*7)

        return #Predicate<log> { log in
                log.logDate > weekAgo
        }
    }
    
    static func calculatePercentage(day1: Double, day2: Double) -> String {
        let division = (day1 / day2) * 100
        let string = String(format: "%.2f", division)
        return string
    }
        
}
