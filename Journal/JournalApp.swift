//
//  JournalApp.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/23.
//

import SwiftUI
import SwiftData

@main
struct JournalApp: App {
    var body: some Scene {
        @StateObject var viewModel = JournalViewModel()
        
        WindowGroup {
            JournalView(viewModel: viewModel)
                .modelContainer(for: log.self)
        } // https://qiita.com/dokozon0/items/0c46c432b2e873ceeb04 これをしないとクラッシュするらしい。

    }
}
