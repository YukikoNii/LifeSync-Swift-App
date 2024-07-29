//
//  ContentView.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/23.
//

import SwiftUI

struct JournalView: View {
    @ObservedObject var viewModel: JournalViewModel

    
    @State private var sliderVal : Double = 0
    
    @State var selection = 1
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            PageOneView(viewModel: viewModel)
                .tabItem {
                    Image(systemName:"house") // TODO: make images larger
                }
                .tag(1)
                .badge(1) // ⬅︎ Int
            
            PageTwoView()
                .tabItem {
                    Image(systemName:"plus.app.fill")
                }
                .tag(2)
            
            PageThreeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName:"chart.xyaxis.line")
                }
                .tag(3)
        }
        .onAppear() {
            UITabBar.appearance().unselectedItemTintColor = .white
            UITabBar.appearance().backgroundColor = .black
        }
        .tint(Color("Color"))
    }
    
}
   

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(viewModel: JournalViewModel())
    }
}
