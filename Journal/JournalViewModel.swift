//
//  JournalViewModel.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/24.
//

import SwiftUI
import Foundation

class JournalViewModel: ObservableObject {
    
    //@Published private var model = journalModel()

    @Published var name = "Bob"
    
    @Published var username = ""
    
    @Published var email = ""
    
    @Published var password = ""
    
    @Published var reminderTimes = setDefaultReminderTime(numOfReminders: 3)
        
}

func setDefaultReminderTime(numOfReminders: Int) -> [Date] {
    
    let dateComponents: [[String: Int]] = [["hour": 9, "minute": 0], ["hour": 13, "minute": 0], ["hour": 20, "minute": 0]]
    
    var dates: [Date] = []
    
    
    for index in 0...(numOfReminders-1) {
        
        var components = DateComponents()
        components.hour = dateComponents[index]["hour"]
        components.minute = dateComponents[index]["minute"]
        
        let date = Calendar.current.date(from: components) ?? .now
        dates.append(date)
        
    }
    
    return dates.sorted()
    
}




