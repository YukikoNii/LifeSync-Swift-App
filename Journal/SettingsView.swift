//
//  PageThreeView.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    
    
    /* init(viewModel: viewModel) {
    
      // TODO: I want to be able to change the color.
        } */
    //https://stackoverflow.com/questions/77664511/how-to-change-navigation-title-color-in-swiftui
     
    var body: some View {
        
            NavigationStack {
                ZStack {
                    Color("Sec")
                        .ignoresSafeArea()
                
                    List(settingRows, id:\.id) { settingRow in
                        
                        NavigationLink(settingRow.name) {
                            SettingsDetailsView(viewModel: viewModel, category: settingRow.name) // For some reason, NavigationDestination didn't work.
                        }
                        .font(.system(18))
                        .listRowBackground(Color("Prim"))
                        .foregroundColor(Color("Sec"))
                
                    
                } // List
                .scrollContentBackground(.hidden)


            } // ZStack
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .foregroundColor(Color("Prim"))
                        .font(.system(18))
                }
            }
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
        settingRow(name: "Configuration", icon: "", id:2),
        settingRow(name: "Help", icon: "", id:3) // you need to have id and it needs to be hashable, otherwise it navigates back immediately.
    ]
}

struct SettingsDetailsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    let category: String
            
    var body: some View {
        
        if category == "Profile" {
            
                ZStack {
                    Color("Sec")
                        .ignoresSafeArea()
                
                List {
                    
                    TextField("Name", text: $viewModel.name)
                        .disableAutocorrection(true)
                    
                    TextField("Username", text: $viewModel.username)
                        .disableAutocorrection(true)
                    
                    TextField("Email", text: $viewModel.email)
                        .disableAutocorrection(true)
                    
                    
                    SecureField("Password", text: $viewModel.password)
                    
                } // List
                .navigationBarTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear() { // init() didn't work because I didn't know how to initialize viewmodel, so I decided to use onAppear. It's working fine so far.
                        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.secondary, .font:UIFont.titillium]

                }

            } // ZStack
            .scrollContentBackground(.hidden)

        } // if profile

       
    }
}

