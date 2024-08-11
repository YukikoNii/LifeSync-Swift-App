//
//  ContentView.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/23.
//

import SwiftUI
import SwiftData

struct JournalView: View {
    @ObservedObject var viewModel: JournalViewModel

    @State private var sliderVal : Double = 0
    
    @State var selection = 1
    

    var body: some View {
        
        TabView(selection: $selection) {
            
            HomeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName:"house") // TODO: make images larger
                }
                .tag(1)
                .badge(1)
            
            LogView(viewModel: viewModel)
                .tabItem {
                    Image(systemName:"plus.app.fill")
                }
                .tag(2)
            
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName:"list.bullet.clipboard.fill")
                }
                .tag(4)
        }
        .onAppear() {
            UITabBar.appearance().unselectedItemTintColor = .white
            UITabBar.appearance().backgroundColor = .tertiary
        }
        .tint(Color("Prim"))
    }
    
}
   

#Preview {
        JournalView(viewModel: JournalViewModel())
        .modelContainer(for: [stressLog.self, day.self, dailyLog.self], inMemory:true)
    // Someone suggested that if the problem is only within Preview, inMemory: true works.
    // https://www.hackingwithswift.com/forums/100-days-of-swiftui/day-54-crash-in-preview-of-swiftdata/26510
    //  https://qiita.com/Puyan/items/117e8a266c34a81c393d
}
