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
    static func getDayStressAvg (dayStressLogs: [log]) -> Double {
        let dayStressAvg = dayStressLogs.reduce(0.00) {$0 + $1.stressLevel} / Double(dayStressLogs.count)
        return dayStressAvg
    }
    
    static func logsForToday(date:Date) -> Predicate<log> {
        
        return #Predicate<log> { log in
                    log.logDate > date
        }

    }
}
