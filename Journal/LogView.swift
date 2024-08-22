
import SwiftUI
import SwiftData
import Foundation

struct LogView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State var index = 0

    var body: some View {
            
            ZStack {
                
                Color("Sec")
                    .ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Text("Stress Log")
                            .padding()
                            .background(index == 0 ? Color("Var") : Color("Sec"))
                            .foregroundColor(index == 0 ? Color("Prim") : Color("Prim"))
                            .font(.system(17))
                            .clipShape(.rect(cornerRadius:5))
                            .onTapGesture {
                                index = 0
                            }
                        
                        Text("Factors Log")
                            .padding()
                            .background(index == 1 ? Color("Var") : Color("Sec"))
                            .foregroundColor(index == 1 ? Color("Prim") : Color("Prim"))
                            .font(.system(17))
                            .clipShape(.rect(cornerRadius:5))
                            .onTapGesture {
                                index = 1
                            }
                    }
                    
                    
                    TabView(selection:$index) {
                        
                        // Stress Tracker which you can log as many times as you want each day.
                        StressTrackerView(viewModel: viewModel)
                            .tag(0)
                        
                        // Daily log
                        DailyLogView()
                            .tag(1)
                        
                    }// TabView
                } // VStack
                
            } // ZStack

    }
}


struct StressTrackerView: View {
    @ObservedObject var viewModel: JournalViewModel

    @State private var stressLevel : Double = 5
    @State private var stressDate = Date()
    @State private var notes = ""
    @Environment(\.modelContext) var context
    
    
    var body: some View {
        
        ZStack {
            Color("Sec")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    
                    Button {
                        stressDate = Date()
                    } label: {
                        Text("Reset")
                    }
                    .padding()
                    
                    
                    DatePicker("", selection: $stressDate, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding()
                    
                }
                
                Text("Stress Level: \(stressLevel, specifier:"%.0f")")
                    .padding()
                //.frame(maxWidth:.infinity, alignment: .leading)
                //https://t32k.me/mol/log/text-align-swiftui/
                Slider(value: $stressLevel, in: 0...10, step:1,  minimumValueLabel: Text("Low"),
                       maximumValueLabel: Text("High"),
                       label: { EmptyView() })
                .padding(.horizontal)
                .tint(Color("Prim"))
                
                Button("Submit") {
                    let newLog = stressLog(logDate: stressDate, stressLevel: stressLevel, notes: notes, id: UUID().uuidString)
                    context.insert(newLog)
                    stressLevel = 5
                    
                } // Button
                .padding()
                .buttonStyle(.bordered)
                .tint(.white)
                
            }
            .padding()
            .background(Color("Var"))
            .clipShape(.rect(cornerRadius: 20))
            .font(.system(16))
            .foregroundStyle(Color("Prim"))
            .padding(20)
        }
        
    }
}

struct DailyLogView: View { // TODO: only allow one log per day.
    @Environment(\.modelContext) var context
    
    @State private var sleep : Double = 0
    @State private var activity : Double = 0
    @State private var work : Double = 0
    @State private var diet : Double = 0
    @State private var dateDaily = Date()
    @State private var journal = ""
    
    @Query(filter: stressLog.dayLog(date:Date.now)) var todaysLogs: [stressLog]

    var body: some View {
        
        ZStack {
            Color("Sec")
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack {
                    
                    DatePicker("", selection: $dateDaily, displayedComponents: [.date])
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding()
                    
                    //https://zenn.dev/joo_hashi/books/ccb8a3799ce7ba/viewer/8ae4e2
                    
                    Divider()
                    
                    Text("Sleep: \(sleep, specifier:"%.1f") hours")
                        .padding()
                    Slider(value: $sleep, in: 0...10, step:0.5,  minimumValueLabel: Text("0"),
                           maximumValueLabel: Text("10h+"),
                           label: { EmptyView() })
                    .padding(.horizontal)
                    .tint(Color("Prim"))
                    
                    
                    Text("Activity: \(activity, specifier:"%.0f")")
                        .padding()
                    Slider(value: $activity, in: 0...10, step:1,  minimumValueLabel: Text("Low"),
                           maximumValueLabel: Text("High"),
                           label: { EmptyView() })
                    .padding(.horizontal)
                    .tint(Color("Prim"))
                    
                    Text("Diet: \(diet, specifier:"%.0f")")
                        .padding()
                    Slider(value: $diet, in: 0...10, step:1,  minimumValueLabel: Text("Poor"),
                           maximumValueLabel: Text("Good"),
                           label: { EmptyView() })
                    .padding(.horizontal)
                    .tint(Color("Prim"))
                    
                    
                    Text("Work: \(work, specifier:"%.0f")")
                        .padding()
                    Slider(value: $work, in: 0...10, step:1,  minimumValueLabel: Text("Low"),
                           maximumValueLabel: Text("High"),
                           label: { EmptyView() })
                    .padding(.horizontal)
                    .tint(Color("Prim"))
                    
                    
                    Text("Journal")
                    
                    TextField("Anything else?", text: $journal)
                        .padding()
                        .foregroundStyle(Color("Prim"))
                    
                    
                    Button("Submit") {
                        let dailyFactorsLog = dailyFactorsLog(sleep: sleep, activity: activity, diet: diet, work: work, journal: journal, logDate: dateDaily)
                        
                        
                        context.insert(dailyFactorsLog)
                        
                        if !stressLog.getStressAvg(dayStressLogs: todaysLogs).isNaN {
                            
                            let daySummary = daySummary(logDate: Date.now, avgStress: stressLog.getStressAvg(dayStressLogs: todaysLogs), sleep: sleep, activity: activity, diet: diet, work: work)
                            context.insert(daySummary)
                            
                        }
                        
                    } // Button
                    .padding()
                    .buttonStyle(.bordered)
                    .tint(.white)
                    
                } // VStack
                .padding()
                .background(Color("Var"))
                .clipShape(.rect(cornerRadius: 20))
                .font(.system(16))
                .foregroundStyle(Color("Prim"))
                .padding(20)
            }
        }
    }
}
