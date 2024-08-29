//
//  File.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/25.
//

import Foundation
import SQLite

let file_name = "dailyLogs.db"

class Database {
    var db: Connection
    
    init() {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(file_name).path // https://qiita.com/ao2-y/items/1483c95e16dea0629127
        
        db = try! Connection(filePath)
        
    }
}
