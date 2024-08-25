

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    struct settingRow: Identifiable {
        
        var name:String
        var id = UUID() // you need to have id
        
    }
    
    var settingRows = [
        settingRow(name: "Profile"),
        settingRow(name: "Notification"),
    ]
    
    //https://stackoverflow.com/questions/77664511/how-to-change-navigation-title-color-in-swiftui
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color("Sec")
                    .ignoresSafeArea()
                
                List(settingRows, id:\.id) { settingRow in
                    
                    NavigationLink(settingRow.name) {
                        SettingsDetailsView(viewModel: viewModel, category: settingRow.name)
                    }
                    .listRowBackground(Color("Tint"))
                    .foregroundColor(Color("Prim"))
                    
                } // List
                .scrollContentBackground(.hidden)
                
                
            } // ZStack
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .foregroundColor(Color("Prim"))
                }
            }
        } // NavigationStack
        .font(.system(18))
        
        
    } //body
}



struct SettingsDetailsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    let category: String


    
    var body: some View {
        
        ZStack {
            Color("Sec")
                .ignoresSafeArea()
            
            List {
                if category == "Profile" {
                    
                    TextField("Name", text: $viewModel.name)
                        .disableAutocorrection(true)
                        .listRowBackground(Color("Tint"))
                    
                    
                    TextField("Username", text: $viewModel.username)
                        .disableAutocorrection(true)
                        .listRowBackground(Color("Tint"))
                    
                    
                    TextField("Email", text: $viewModel.email)
                        .disableAutocorrection(true)
                        .listRowBackground(Color("Tint"))
                    
                    
                    SecureField("Password", text: $viewModel.password)
                        .listRowBackground(Color("Tint"))
                    
                } // if profile
                
                if category == "Notification" {
                    
                    Section {
                        
                    
                        VStack { // TODO: maybe I should use a loop
                            
                            Toggle("Reminder Time 1", isOn: $viewModel.isStressLogsRemindersOn[0])
                            
                                                    
                            DatePicker("", selection: $viewModel.stressLogsReminderTime[0], displayedComponents: [.hourAndMinute])
                                .disabled(!viewModel.isStressLogsRemindersOn[0])
                            
                        }
                        
                        VStack {
                            
                            Toggle("Reminder Time 2", isOn: $viewModel.isStressLogsRemindersOn[1])
                            
                                                    
                            DatePicker("", selection: $viewModel.stressLogsReminderTime[1], displayedComponents: [.hourAndMinute])
                                .disabled(!viewModel.isStressLogsRemindersOn[1])
                            
                        }
                        
                        VStack {
                            
                            Toggle("Reminder Time 3", isOn: $viewModel.isStressLogsRemindersOn[2])
                            
                                                    
                            DatePicker("", selection: $viewModel.stressLogsReminderTime[2], displayedComponents: [.hourAndMinute])
                                .disabled(!viewModel.isStressLogsRemindersOn[2])
                            
                        }
                        
                    } header: {
                        Text("Stress Log Reminder")
                    }
                    .listRowBackground(Color("Tint"))
                    
                    Section {
                        
                        VStack {
                            
                            Toggle("Reminder Time", isOn: $viewModel.isDailyLogReminderOn[0])
                            
                                                    
                            DatePicker("", selection: $viewModel.dailyLogReminderTime[0], displayedComponents: [.hourAndMinute])
                                .disabled(!viewModel.isDailyLogReminderOn[0])
                            
                        }
                                            
                        
                    } header: {
                        Text("Daily Log Reminder")
                    }
                    .listRowBackground(Color("Tint"))
                    
                } // if category
                
            } // List
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("Sec"))
            .foregroundStyle(Color("Prim"))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(category)")
                        .foregroundColor(Color("Prim"))
                        .font(.system(18))
                }
            }
            
            
        }
        .font(.system(18))
        
    }
    
}


