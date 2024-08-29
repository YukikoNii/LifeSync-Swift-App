

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    
    var settingRows = [
       "Profile",
       "Notification"
    ]
    
    //https://stackoverflow.com/questions/77664511/how-to-change-navigation-title-color-in-swiftui
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color("Prim")
                    .ignoresSafeArea()
                
                List(settingRows, id:\.self) { settingRow in
                    
                    NavigationLink(settingRow) {
                        SettingsDetailsView(viewModel: viewModel, category: settingRow)
                    }
                    .listRowBackground(Color("Tint"))
                    .foregroundColor(Color("Sec"))
                    
                } // List
                .scrollContentBackground(.hidden)
                
                
            } // ZStack
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .foregroundColor(Color("Sec"))
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
            Color("Prim")
                .ignoresSafeArea()
            
            List {
                switch category {
                case "Profile":
                    
                    TextField("Name", text: $viewModel.name)
                        .listRowBackground(Color("Tint"))
                        .keyboardType(.default) 
                    
                    
                    TextField("Username", text: $viewModel.username)
                        .listRowBackground(Color("Tint"))
                    
                    
                    TextField("Email", text: $viewModel.email)
                        .listRowBackground(Color("Tint"))
                    
                    
                    SecureField("Password", text: $viewModel.password)
                        .listRowBackground(Color("Tint"))
                    
                    
                case "Notification":
                    
                    // stress log notifications
                    Section {
                        
                        ForEach(0..<viewModel.numOfStressNotifications, id: \.self) { index in
                            VStack {
                                
                                Toggle("Notification Time \(index + 1)", isOn: $viewModel.isStressLogsNotificationsOn[index])
                                    .onChange(of: viewModel.isStressLogsNotificationsOn[index]) {
                                        if viewModel.isStressLogsNotificationsOn[index] == true {
                                            let components = Calendar.current.dateComponents(in: TimeZone.current, from: viewModel.stressLogsNotificationTime[index])
                                            
                                            setNotification(hour: components.hour!, minute: components.minute!, identifier: UUID().uuidString) // trigger notification
                                            
                                        } else {
                                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(index)])
                                        }
                                    }
                                
                                
                                DatePicker("", selection: $viewModel.stressLogsNotificationTime[index], displayedComponents: [.hourAndMinute])
                                    .disabled(!viewModel.isStressLogsNotificationsOn[index])
                                    .onChange(of: viewModel.stressLogsNotificationTime[index]) {
                                        let components = Calendar.current.dateComponents(in: TimeZone.current, from: viewModel.stressLogsNotificationTime[index])
                                        
                                        setNotification(hour: components.hour!, minute: components.minute!, identifier: String(index)) // trigger notification
                                    }
                            }
                            
                        }
                        
                        
                        
                    } header: {
                        Text("Stress Log Notification")
                    }
                    .listRowBackground(Color("Tint"))
                    
                    // metrics log notifications
                    Section {
                        
                        VStack {
                            
                            Toggle("Notification Time", isOn: $viewModel.isDailyLogNotificationOn[0])
                                .onChange(of: viewModel.isDailyLogNotificationOn[0]) {
                                    if viewModel.isDailyLogNotificationOn[0] == true {
                                        let components = Calendar.current.dateComponents(in: TimeZone.current, from: viewModel.dailyLogNotificationTime[0])
                                        
                                        setNotification(hour: components.hour!, minute: components.minute!, identifier: String(3)) // trigger notification
                                        
                                    } else {
                                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(3)])
                                    }
                                }
                            
                            DatePicker("", selection: $viewModel.dailyLogNotificationTime[0], displayedComponents: [.hourAndMinute])
                                .disabled(!viewModel.isDailyLogNotificationOn[0])
                                .onChange(of: viewModel.dailyLogNotificationTime[0]) {
                                    let components = Calendar.current.dateComponents(in: TimeZone.current, from: viewModel.dailyLogNotificationTime[0])
                                    
                                    setNotification(hour: components.hour!, minute: components.minute!, identifier: String(3)) // trigger notification
                                }
                            
                        }
                    } header: {
                        Text("Daily Log Notification")
                    }
                    .listRowBackground(Color("Tint"))
                    
                default:
                    Text("Something went wrong.")
                    
                }
                    
                
            } // List
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("Prim"))
            .foregroundStyle(Color("Sec"))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(category)")
                        .foregroundColor(Color("Sec"))
                        .font(.system(18))
                }
            }
            
            
        }
        .font(.system(18))
        
    }
    
}





