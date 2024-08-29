//
//  Calendar Extension.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/08/28.
//

import SwiftUI

extension Calendar {
    func numOfDaysInBetween(from startDate: Date, to endDate: Date) -> Int {
        let start = startOfDay(for: startDate) // <1>
        let end = startOfDay(for: endDate) // <2>
        let numberOfDays = dateComponents([.day], from: start, to: end) // <3>
                
        return numberOfDays.day!
        
    } // https://sarunw.com/posts/getting-number-of-days-between-two-dates/
}
