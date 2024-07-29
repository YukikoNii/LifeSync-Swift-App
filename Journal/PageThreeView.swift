//
//  PageThreeView.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/24.
//

import SwiftUI

struct PageThreeView: View {
    @ObservedObject var viewModel: JournalViewModel

    
    /*init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]

        } https://stackoverflow.com/questions/77664511/how-to-change-navigation-title-color-in-swiftui */
     
    var body: some View {
        
            NavigationStack {
                
                ZStack {
                    Color("Color")
                        .ignoresSafeArea()
                
                List(settingRows) { settingRow in
                    
                    NavigationLink(settingRow.name, value: settingRow.name)
                        .font(.system(18))
                    
                } // List
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { category in
                    SettingsView(viewModel: viewModel, category:category)
                    
                }
                .listRowBackground(Color.green)

            } // ZStack
            .scrollContentBackground(.hidden)

        
        } // NavigationStack
        
    } //body
    
    struct settingRow: Identifiable, Hashable {
        
        var name:String
        var icon: String
        var id: Int // should I use UUID? (It cause dtoo many errors)

    }
    
    var settingRows = [
        settingRow(name: "Profile", icon: "", id:0),
        settingRow(name: "Notification", icon: "", id:1),
        settingRow(name: "Analysis", icon: "", id:2),
        settingRow(name: "PRO+", icon: "", id:3)
    ]
    
    

}

struct SettingsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    let category: String
            
    var body: some View {
        
        if category == "Profile" {
                
                ZStack {
                    Color("Color")
                        .ignoresSafeArea()
                
                List {
                    
                    TextField("Username", text: $viewModel.name)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $viewModel.password)
                    
                } // List
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)


            } // ZStack
            .scrollContentBackground(.hidden)

        } // if profile

       
    }
}

