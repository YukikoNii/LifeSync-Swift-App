

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
    
    let frequencies = ["Every week", "Every 2 days", "Every day", "2x/day", "3x/day"]
    
    @State private var selectedFrequency = "3x/day"
    
    @State private var selectedTime1 = reminderTime1()
    @State private var selectedTime2 = Date()
    @State private var selectedTime3 = Date()
    
    
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
                        
                        DatePicker("Reminder Time 1", selection: $selectedTime1, displayedComponents: [.hourAndMinute])
                        DatePicker("Reminder Time 2", selection: $selectedTime2, displayedComponents: [.hourAndMinute])
                        DatePicker("Reminder Time 3", selection: $selectedTime3, displayedComponents: [.hourAndMinute])
                        
                        
                    } header: {
                        Text("Stress Logs Reminder")
                    } footer: {
                        Text("If the frequency is less than 3x/day, reminder time 1 is used.")
                            .font(.system(16))
                    }
                    .listRowBackground(Color("Tint"))
                    
                }
                
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



func reminderTime1() -> Date {
    
    var components = DateComponents()
    components.hour = 8
    components.minute = 30
    
    let date = Calendar.current.date(from: components) ?? .now
    
    return date
}
