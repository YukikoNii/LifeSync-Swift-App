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

    @Published var name = "New User"
    
    @Published var username = ""
    
    @Published var email = ""
    
    @Published var password = ""
    
    @Published var numOfStressNotifications = 3
        
    @Published var stressLogsNotificationTime = setDefaultNotificationTime(numOfNotifications: 3) // TODO: I probably shouldn't have this magic number. 
    
    @Published var isStressLogsNotificationsOn = [false, false, false]
    
    @Published var dailyLogNotificationTime = setDefaultNotificationTime(numOfNotifications: 1)
    
    @Published var isDailyLogNotificationOn = [false]
    
    
}

func setDefaultNotificationTime(numOfNotifications: Int) -> [Date] {
    
    let dateComponents: [[String: Int]] = [["hour": 9, "minute": 0], ["hour": 13, "minute": 0], ["hour": 20, "minute": 0]]
    
    var dates: [Date] = []
    
    for index in 0...(numOfNotifications-1) {
        
        var components = DateComponents()
        components.hour = dateComponents[index]["hour"]
        components.minute = dateComponents[index]["minute"]
        
        let date = Calendar.current.date(from: components) ?? .now
        dates.append(date)
        
    }
    
    return dates.sorted()
    
}



