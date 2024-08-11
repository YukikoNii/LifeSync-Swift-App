//
//  PageThreeView.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    
    
    /* init() {
      // TODO: I want to be able to change the color.
        } */
    //https://stackoverflow.com/questions/77664511/how-to-change-navigation-title-color-in-swiftui
     
    var body: some View {
        
            NavigationStack {
                
                
                ZStack {
                    Color("Prim")
                
                    List(settingRows, id:\.id) { settingRow in
                        
                        NavigationLink(settingRow.name) {
                            SettingsDetailsView(viewModel: viewModel, category: settingRow.name) // For some reason, NavigationDestination didn't work.
                        }
                        .font(.system(18))
                        .listRowBackground(Color("Sec"))
                        .foregroundColor(Color("Prim"))
                
                    
                } // List
                .scrollContentBackground(.hidden)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)

            } // ZStack
            .scrollContentBackground(.hidden)

        
        } // NavigationStack
        .onAppear() { // init() didn't work because I didn't know how to initialize viewmodel, so I decided to use onAppear. It's working fine so far.
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tertiary, .font:UIFont.titillium]
        }
        .tint(Color("Sec")) // Change Navigation View Back button (arrow) color
        
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
        settingRow(name: "Help", icon: "", id:3) // you need to have id and it needs to be hashable, otherwise it navigates back immediately.
    ]
    
    

}

struct SettingsDetailsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    let category: String
            
    var body: some View {
        
        if category == "Profile" {
            
                
                ZStack {
                    Color("Prim")
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
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)


            } // ZStack
            .scrollContentBackground(.hidden)

        } // if profile

       
    }
}

