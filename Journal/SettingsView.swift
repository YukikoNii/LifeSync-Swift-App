

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
        settingRow(name: "Configuration"),
        settingRow(name: "Help")
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
    
    let frequencies = ["Every week", "Every day", "2x/day", "3x/day"]
    
    @State private var selectedFrequency = "3x/day"
    
    @State private var selectedTime2 = Date()
    @State private var selectedTime3 = Date()
    
    @State private var time1On = false
    @State private var time2On = false
    @State private var time3On = false

    
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
                        
                        Picker("Frequency", selection: $selectedFrequency) {
                            ForEach(frequencies, id:\.self) { frequency in
                                Text(frequency)
                                    .font(.system(18))
                            }
                        }
                        
                        VStack {
                            
                            Toggle("Reminder Time 1", isOn: $time1On)
                            
                                                    
                            DatePicker("", selection: $viewModel.reminderTimes[0], displayedComponents: [.hourAndMinute])
                                .disabled(!time1On)
                            
                        }
                        
                        VStack {
                            
                            Toggle("Reminder Time 2", isOn: $time2On)
                            
                                                    
                            DatePicker("", selection: $viewModel.reminderTimes[1], displayedComponents: [.hourAndMinute])
                                .disabled(!time2On)
                            
                        }
                        
                        VStack {
                            
                            Toggle("Reminder Time 3", isOn: $time3On)
                            
                                                    
                            DatePicker("", selection: $viewModel.reminderTimes[2], displayedComponents: [.hourAndMinute])
                                .disabled(!time3On)
                            
                        }
                                            
                        
                    } header: {
                        Text("Stress Logs Reminder")
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


