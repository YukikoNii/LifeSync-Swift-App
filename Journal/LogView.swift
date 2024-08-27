
import SwiftUI
import SwiftData
import Foundation

struct LogView: View {

    @ObservedObject var viewModel: JournalViewModel
    @State var page = 0

    

    var body: some View {
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()
            
            VStack {
                
                LogTypePickerView(page: $page)
                
                
                TabView(selection:$page) {
                    
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
    
    @Query var allmetricsLogs: [metricsLog]
    @Query var allStressLogs: [stressLog]

    
    var body: some View {
        
        ZStack {
            Color("Sec")
                .ignoresSafeArea()
            
            ScrollView {
                
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
                            .padding()
                        
                    }
                    
                    Text("Stress Level: \(stressLevel, specifier:"%.0f")")
                        .padding()
                    //https://t32k.me/mol/log/text-align-swiftui/
                    
                    Slider(value: $stressLevel, in: 0...10, step:1,  minimumValueLabel: Text("Low"),
                           maximumValueLabel: Text("High"),
                           label: { EmptyView() })
                    .padding(.horizontal)
                    .tint(Color("Prim"))
                    
                    Text("Notes")
                    
                    TextField("How are you feeling now?", text: $notes)
                        .padding()
                        .foregroundStyle(Color("Prim"))
                        .font(.system(16))
                
                    
                    Button("Log") {
                        let newLog = stressLog(logDate: stressDate, stressLevel: stressLevel, notes: notes, id: UUID().uuidString)
                        context.insert(newLog)
                        stressLevel = 5
                        
                        createSummaryLog(metricsLogs: allmetricsLogs, stressLogs: allStressLogs, context: context)

                        
                    } // Button
                    .padding()
                    .buttonStyle(.bordered)
                    .tint(.white)
                    
                } //VStack
                .padding()
                .background(Color("Tint"))
                .clipShape(.rect(cornerRadius: 20))
                .font(.system(16))
                .foregroundStyle(Color("Prim"))
                .padding(20)
                
            }//ScrollView
            .toolbarBackground(Color("Sec"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            
        }
        
    }
}

struct DailyLogView: View {
    @Environment(\.modelContext) var context
    
    @State private var sleep : Double = 0
    @State private var activity : Double = 0
    @State private var work : Double = 0
    @State private var diet : Double = 0
    @State private var metricsLogDate = Date()
    @State private var journal = ""
    
    
    @Query var allmetricsLogs: [metricsLog]
    @Query var allStressLogs: [stressLog]
    
    @Query(filter: stressLog.dayLog(date:Date.now)) var todaysLogs: [stressLog]
    
    var body: some View {
        
        ZStack {
            Color("Sec")
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack {
                    
                    DatePicker("", selection: $metricsLogDate, displayedComponents: [.date])
                        .labelsHidden()
                        .padding()
                    
                    //https://zenn.dev/joo_hashi/books/ccb8a3799ce7ba/viewer/8ae4e2
                    
                    Divider()
                    
                    Text("Sleep: \(sleep, specifier:"%.1f")")
                        .padding()
                    Slider(value: $sleep, in: 0...10, step:0.5,  minimumValueLabel: Text("Poor"),
                           maximumValueLabel: Text("Good"),
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
                    
                    TextField("How was your day?", text: $journal) // It seems that textfield only works in a larger space?? so sticking to textfield.
                        .padding()
                        .foregroundStyle(Color("Prim"))
                    

                    Button("Log") {
                        let log = metricsLog(sleep: sleep, activity: activity, diet: diet, work: work, journal: journal, logDate: Calendar.current.startOfDay(for: metricsLogDate))
                        
                        context.insert(log)
                        
                        createSummaryLog(metricsLogs: allmetricsLogs, stressLogs: allStressLogs, context: context)

                        
                    } // Button
                    .padding()
                    .buttonStyle(.bordered)
                    .tint(.white)
                    
            
                    
                } // VStack
                .padding()
                .background(Color("Tint"))
                .clipShape(.rect(cornerRadius: 20))
                .font(.system(16))
                .foregroundStyle(Color("Prim"))
                .padding(20)
                
            }//scrollview
            .toolbarBackground(Color("Sec"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

/*
func createTimer() {
    let timer = Timer(fireAt: Date.now, interval: 86400, target: self, selector: #selector(createSummaryLog), userInfo: nil, repeats: true)
    RunLoop.main.add(timer, forMode: .common)
}

@objc func createSummaryLog(stressLogsForToday: [stressLog], dailyMetricsLogForToday: dailyMetricsLog) {
    
    if !stressLog.getStressAvg(dayStressLogs: stressLogsForToday).isNaN {
        
        let daySummary = daySummary(logDate: Date.now, avgStress: stressLog.getStressAvg(dayStressLogs: todaysLogs), sleep: sleep, activity: activity, diet: diet, work: work)
        context.insert(daySummary)
        
    }
}
 */




struct LogTypePickerView: View {
    
    @Binding var page: Int
    
    var body: some View {
        HStack { 
            Text("Stress Log")
                .padding()
                .background(page == 0 ? Color("Tint") : Color("Sec"))
                .foregroundColor(page == 0 ? Color("Prim") : Color("Prim"))
                .clipShape(.rect(cornerRadius:5))
                .onTapGesture {
                    page = 0
                }
            
            Text("Metrics Log")
                .padding()
                .background(page == 1 ? Color("Tint") : Color("Sec"))
                .foregroundColor(page == 1 ? Color("Prim") : Color("Prim"))
                .clipShape(.rect(cornerRadius:5))
                .onTapGesture {
                    page = 1
                }
        }
        .font(.system(17))
    }
}
