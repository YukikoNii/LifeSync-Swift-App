//
//  JournalApp.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/23.
//

import SwiftUI

@main
struct JournalApp: App {
    var body: some Scene {
        @StateObject var viewModel = JournalViewModel()
        
        WindowGroup {
            JournalView(viewModel: viewModel)
        }
    }
}
