

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
                
                List{
                    
                    Section {
                        
                        ForEach(settingRows, id:\.self) { settingRow in
                            
                            NavigationLink(settingRow) {
                                SettingsDetailsView(viewModel: viewModel, category: settingRow)
                            }
                            .listRowBackground(Color("Tint"))
                            .foregroundColor(Color("Sec"))
                            
                        }
                        
                    }
                    
                } // List
                
                
            } // ZStack
            .scrollContentBackground(.hidden)
            .font(.system(18))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .foregroundColor(Color("Sec"))
                        .font(.systemSemiBold(20))
                    
                }
            }
            
        }
        
        
    } //body
}


struct SettingsDetailsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    let category: String
    
    var body: some View {
        
        ZStack {
            Color("Prim")
                .ignoresSafeArea()
            
            switch category {
            case "Profile":
                ProfileDetailsView(viewModel: viewModel, category: category)
            case "Notification":
                NotificationDetailsView(viewModel: viewModel, category: category)
            default:
                Text("Something went wrong.")
                
            }
        }
        .font(.system(18))
        
    }
    
}


struct TabTitleView: View {
    
    var text: String
    
    var body: some View {
        Text("\(text)")
            .foregroundColor(Color("Sec"))
            .font(.systemSemiBold(20))
            .padding(5)
        
        Divider()
        
    }
}

struct ProfileDetailsView: View {
    @ObservedObject var viewModel: JournalViewModel
    var category: String
    
    var body: some View {
        
        List {
            TextField("Name", text: $viewModel.name)
                .listRowBackground(Color("Tint"))
            
            
            TextField("Username", text: $viewModel.username)
                .listRowBackground(Color("Tint"))
            
            
            TextField("Email", text: $viewModel.email)
                .listRowBackground(Color("Tint"))
            
            
            SecureField("Password", text: $viewModel.password)
                .listRowBackground(Color("Tint"))
            
        }
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("Prim"))
        .foregroundStyle(Color("Sec"))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(category)")
                    .foregroundColor(Color("Sec"))
                    .font(.systemSemiBold(20))
            }
        }
    }
}

struct NotificationDetailsView: View {
    @ObservedObject var viewModel: JournalViewModel
    var category: String

    var body: some View {
        List {
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
            
        } // list
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("Prim"))
        .foregroundStyle(Color("Sec"))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(category)")
                    .foregroundColor(Color("Sec"))
                    .font(.systemSemiBold(20))
            }
        }
    }
}
