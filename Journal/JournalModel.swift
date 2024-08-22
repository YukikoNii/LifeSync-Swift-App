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
    
    static func calculatePercentage(day1: Double, day2: Double) -> String {
        let division = (day1 / day2) * 100
        let string = String(format: "%.2f", division)
        return string
    }
    
    static func calcWeekdayAvgs (dayStressLogs: [stressLog]) -> [Double] {
        var weekdayAvgs = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        for index in 1...7 {
            let weekday = dayStressLogs.filter({ Calendar.current.component(.weekday, from: $0.logDate) == index})
            let avg = weekday.reduce(0.00) {$0 + $1.stressLevel} / Double(weekday.count)
            weekdayAvgs[index - 1] = avg
        }
        
        return weekdayAvgs
        
    }
    
    static func calcTimeOfDayAvgs (dayStressLogs: [stressLog]) -> [Double] {
        var timeOfDayAvgs = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        for index in 0...7 {
            let timeSpan = dayStressLogs.filter({ 3*index <= Calendar.current.component(.hour, from: $0.logDate) && Calendar.current.component(.hour, from: $0.logDate) <= 3*(index+1)})
            
            let avg = timeSpan.reduce(0.00) {$0 + $1.stressLevel} / Double(timeSpan.count)
            
            timeOfDayAvgs[index] = avg
        }
        return timeOfDayAvgs
    }
    
}



@Model
class daySummary {
    var logDate: Date
    var avgStress: Double
    var sleep: Double // I am not sure if this is right.
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
}

extension daySummary {
    
    static func dayLog(date: Date) -> Predicate<daySummary> {
        
        let endDate = Calendar.current.startOfDay(for: date.addingTimeInterval(86400))
        let startDate = Calendar.current.startOfDay(for: date)
        
        return #Predicate<daySummary> { log in
            startDate < log.logDate &&
            log.logDate < endDate // TODO: technically, it doesn't have to be a range. (But calendar can't be used in the predicate, so I don't know how else to do it.)
        }
    }
}

@Model
class dailyFactorsLog {
    var sleep: Double
    var activity: Double
    var diet: Double
    var work: Double
    var journal: String
    var logDate: Date
    
    init(sleep: Double, activity: Double, diet: Double, work: Double, journal: String, logDate: Date) {
        self.sleep = sleep
        self.activity = activity
        self.diet = diet
        self.work = work
        self.journal = journal
        self.logDate = logDate
    }
}

extension dailyFactorsLog {
    
    static func dayLog(date: Date) -> Predicate<dailyFactorsLog> {
        
        let endDate = Calendar.current.startOfDay(for: date.addingTimeInterval(86400))
        let startDate = Calendar.current.startOfDay(for: date)
        
        return #Predicate<dailyFactorsLog> { log in
            startDate < log.logDate &&
            log.logDate < endDate // TODO: technically, it doesn't have to be a range. (But calendar can't be used in the predicate, so I don't know how else to do it.)
        }
    }
    
    static func getSleepAvg (dailyFactorsLogs: [dailyFactorsLog]) -> Double {
        let daySleepAvg = dailyFactorsLogs.reduce(0.00) {$0 + $1.sleep} / Double(dailyFactorsLogs.count)
        return daySleepAvg
    }
    
    static func calculatePercentage(period1: Double, period2: Double) -> String {
        let division = (period1 / period2) * 100
        let string = String(format: "%.2f", division)
        return string
    }
    
}



