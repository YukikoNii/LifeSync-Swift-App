//
//  JournalModel.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/25.
//

import Foundation
import SwiftData

@Model
class stressLog: Identifiable {
    
    var logDate: Date
    var stressLevel: Double
    var id: String
    
    init (logDate: Date, stressLevel: Double, id: String) {
        self.logDate = logDate
        self.stressLevel = stressLevel
        self.id = id // Adding so that it conforms to RandomAccessCollection
    }
}

extension stressLog {
    static func getStressAvg (dayStressLogs: [stressLog]) -> Double {
        let dayStressAvg = dayStressLogs.reduce(0.00) {$0 + $1.stressLevel} / Double(dayStressLogs.count)
        return dayStressAvg
    }
    
    static func dayLog(date: Date) -> Predicate<stressLog> {
        
        let endDate = Calendar.current.startOfDay(for: date.addingTimeInterval(86400))
        let startDate = Calendar.current.startOfDay(for: date)
        
        return #Predicate<stressLog> { log in
            startDate < log.logDate &&
            log.logDate < endDate
        }
    }
    
    static func thisWeeksLogs() -> Predicate<stressLog> {
        
        let date = Date()
        let weekAgo = date.addingTimeInterval(-86400*7)
        
        return #Predicate<stressLog> { log in
            log.logDate > weekAgo
        }
    }
    
    static func calculatePercentage(day1: Double, day2: Double) -> String {
        let division = (day1 / day2) * 100
        let string = String(format: "%.2f", division)
        return string
    }
}
    


@Model
class day {
    var logDate: Date
    var avgStress: Double
    var sleep: dailyLog // I am not sure if this is right.
    
    init(logDate: Date, avgStress: Double, sleep: dailyLog) {
            self.logDate = logDate
            self.avgStress = avgStress
            self.sleep = sleep
        }
}

@Model
class dailyLog {
    var sleep: Double
    var logDate: Date
    
    init (sleep: Double, logDate: Date) {
        self.sleep = sleep
        self.logDate = logDate
    }
}

