//
//  JournalModel.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class stressLog: Identifiable {
    
    var logDate: Date
    var stressLevel: Double
    var notes: String
    var id: String
    
    init (logDate: Date, stressLevel: Double, notes:String, id: String) {
        self.logDate = logDate
        self.stressLevel = stressLevel
        self.notes = notes
        self.id = id // Adding so that it conforms to RandomAccessCollection
    }
}

extension stressLog {
    static func getStressAvg (dayStressLogs: [stressLog]) -> Double {
        let dayStressAvg = dayStressLogs.count > 0 ? dayStressLogs.reduce(0.00) {$0 + $1.stressLevel} / Double(dayStressLogs.count) : 0.0
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
    
    static func calculatePercentage(previous: Double, current: Double) -> String {
        let difference = current - previous
        let string = String(format: "%.2f", abs(difference))
        if difference > 0 {
            return "increase of " + string
        } else {
            return "decrease of " + string
        }
    }
    
    static func calcWeekdayAvgs (dayStressLogs: [stressLog]) -> [Double] {
        var weekdayAvgs = [Double] (repeating: 0.0, count: 7)
        
        for index in 1...7 {
            let weekday = dayStressLogs.filter({ Calendar.current.component(.weekday, from: $0.logDate) == index})
            let avg = weekday.count > 0 ? weekday.reduce(0.00) {$0 + $1.stressLevel} / Double(weekday.count) : 0.0
            // prevent zero division
            weekdayAvgs[index - 1] = avg
        }
        
        return weekdayAvgs
    }
    
    static func calcTimeOfDayAvgs (dayStressLogs: [stressLog]) -> [Double] {
        var timeOfDayAvgs = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        for index in 0...7 {
            let timeSpan = dayStressLogs.filter({ 3*index <= Calendar.current.component(.hour, from: $0.logDate) && Calendar.current.component(.hour, from: $0.logDate) <= 3*(index+1)})
            
            let avg = timeSpan.count > 0 ? timeSpan.reduce(0.00) {$0 + $1.stressLevel} / Double(timeSpan.count) : 0.0
            
            timeOfDayAvgs[index] = avg
        }
        return timeOfDayAvgs
    }
    
}



@Model
class summaryLog {
    @Attribute(.unique) var logDate: Date
    var avgStress: Double
    var sleep: Double
    var activity: Double
    var diet: Double
    var work: Double
    
    init(logDate: Date, avgStress: Double, sleep: Double, activity: Double, diet: Double, work: Double) {
        self.logDate = logDate
        self.avgStress = avgStress
        self.sleep = sleep
        self.activity = activity
        self.diet = diet
        self.work = work
    }
    
    subscript(key: String) -> Double {
        switch key {
        case "Sleep":
            return sleep
        case "Activity":
            return activity
        case "Diet":
            return diet
        case "Work":
            return work
        default:
            return 0.0
        }
        
    }
}

extension summaryLog {
    
    static func dayLog(date: Date) -> Predicate<summaryLog> {
        
        let endDate = Calendar.current.startOfDay(for: date.addingTimeInterval(86400))
        let startDate = Calendar.current.startOfDay(for: date)
        
        return #Predicate<summaryLog> { log in
            startDate < log.logDate &&
            log.logDate < endDate
        }
    }
    
}

@Model
class metricsLog {
    var sleep: Double
    var activity: Double
    var diet: Double
    var work: Double
    var journal: String
    @Attribute(.unique) var logDate: Date
    
    init(sleep: Double, activity: Double, diet: Double, work: Double, journal: String, logDate: Date) {
        self.sleep = sleep
        self.activity = activity
        self.diet = diet
        self.work = work
        self.journal = journal
        self.logDate = logDate
    }
    
    subscript(key: String) -> Double {
        switch key {
        case "Sleep":
            return sleep
        case "Activity":
            return activity
        case "Diet":
            return diet
        case "Work":
            return work
        default:
            return 0.0
        }
        
    }
    // syntax: dailyMetricsLog[key] (no need to call a function called subscript
    // src: ChatGPT
}

extension metricsLog {
    
    static func dayLog(date: Date) -> Predicate<metricsLog> {
        
        let endDate = Calendar.current.startOfDay(for: date.addingTimeInterval(86400))
        let startDate = Calendar.current.startOfDay(for: date)
        
        return #Predicate<metricsLog> { log in
            startDate < log.logDate &&
            log.logDate <= endDate 
        }
    }
    
    static func getAvg (metricsLogs: [metricsLog], metric: String) -> Double {
        
        let daySleepAvg = metricsLogs.reduce(0.00) {$0 + $1[metric]} / Double(metricsLogs.count)
        return daySleepAvg
        
    }
    
    
    static func calculatePercentage(previous: Double, current: Double) -> String {
        let difference = current - previous
        let string = String(format: "%.2f", difference)
        return string
    }
    
    static func calcWeekdayAvgs (logs: [metricsLog], metric: String) -> [Double] {
        var weekdayAvgs = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        for index in 1...7 {
            let weekday = logs.filter({ Calendar.current.component(.weekday, from: $0.logDate) == index})
            
            let avg = weekday.reduce(0.00) { $0 + $1[metric] } / Double(weekday.count)
            weekdayAvgs[index - 1] = avg
        }
        
        return weekdayAvgs
    }
    
    
}



func createSummaryLog(metricsLogs: [metricsLog], stressLogs: [stressLog], context: ModelContext)  { // you can't use @Environment outside of view, have to inject.
    
    for log in metricsLogs {
        let endDate = Calendar.current.startOfDay(for: log.logDate.addingTimeInterval(86400))
        let startDate = Calendar.current.startOfDay(for: log.logDate)
        
        let stressLogsOfDay = stressLogs.filter { startDate <= $0.logDate &&
            $0.logDate <= endDate }
        
        if stressLogsOfDay.count > 0 {
            
            let averageStressOfDay = stressLog.getStressAvg(dayStressLogs: stressLogsOfDay)
            
            let testLog = summaryLog(logDate: log.logDate, avgStress: averageStressOfDay, sleep: log.sleep, activity: log.activity, diet: log.diet, work: log.work)
            
            context.insert(testLog)
        }
    }
}






