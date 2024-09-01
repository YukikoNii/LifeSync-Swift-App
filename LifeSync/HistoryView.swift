
import SwiftUI
import SwiftData
import Foundation

struct HistoryView: View {
    
    @ObservedObject var viewModel: JournalViewModel
    
    @Query(sort: \metricsLog.logDate) var metricsLogs: [metricsLog]
    @State var page = 0
    
    var body: some View {
        
        ZStack {
            
            Color("Prim")
                .ignoresSafeArea()
            
            VStack {
                
                TabTitleView(text: "History")

                
                LogTypePickerView(page: $page)
                
                TabView(selection: $page) {
                    StressHistoryView(viewModel: viewModel)
                        .tag(0)
                    
                    
                    metricsHistoryView(viewModel: viewModel)
                        .tag(1)
                    
                    
                } // TabView
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // This hides the TabBar by making it behave like a paged view src: https://yosshiblog.jp/swiftui_tabview/
                
                /*
                 .onChange(of: scenePhase) {
                 if scenePhase == .active {
                 print("active")
                 }
                 else if scenePhase == .inactive {
                 print("inactive")
                 } else if scenePhase == .background {
                 print("background")
                 }
                 }
                 */
                
                
                
                
            } // VStack
        }//ZStack
    } // body
} // HistoryView



struct StressHistoryView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \stressLog.logDate) var stressLogs: [stressLog]
    
    @Query var allMetricsLogs: [metricsLog]
    @Query var allStressLogs: [stressLog]
    @Query var allSummaryLogs: [summaryLog]
    
    
    var body: some View {
        List {
            
            ForEach(stressLogs) { log in
                
                HStack {
                    VStack (alignment: .leading){
                        
                        Text("\(log.logDate.formatted(date:.complete, time:.shortened))")
                            .foregroundStyle(Color("Sec"))
                            .font(.systemSemiBold(17))
                        
                        VStack(alignment: .leading) {
                            Text("Stress Level: \(String(format: "%.2f", log.stressLevel))") // round to 2dp
                            Text("\(String(log.notes))")
                            
                        }
                        .foregroundStyle(Color("Sec"))
                    }
                    
                    Spacer()
                    
                    Button {
                        context.delete(log)
                        
                        let remainingLogsForDay = stressLogs.filter {
                            Calendar.current.startOfDay(for: log.logDate) <= $0.logDate && $0.logDate <  Calendar.current.startOfDay(for: log.logDate.addingTimeInterval(86400))
                        } //  stressLogs includes the deleted log, so should check count > 1, not count > 0
                        
                        if remainingLogsForDay.count > 0 {
                            
                            createSummaryLog(metricsLogs: allMetricsLogs, stressLogs: allStressLogs, context: context)
                            
                        } else {
                            
                            let summaryLogToBeDeleted: [summaryLog] = allSummaryLogs.filter { Calendar.current.startOfDay(for: log.logDate) <= $0.logDate && $0.logDate <  Calendar.current.startOfDay(for: log.logDate.addingTimeInterval(86400))
                            }
                            
                            if summaryLogToBeDeleted.count > 0 { // if log exists
                                
                                context.delete(summaryLogToBeDeleted[0])
                                
                            }
                            
                        }
                        
                    } label: {
                        Image(systemName:"minus.circle.fill")
                        
                    }
                    .tint(Color("Delete"))
                    .buttonStyle(.bordered)

                    
                }
                .listRowBackground(Color("Tint"))
                .font(.system(17))
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(Color("Prim"))
    }
}

struct metricsHistoryView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \metricsLog.logDate) var metricsLogs: [metricsLog]
    
    @Query var allSummaryLogs: [summaryLog]
    
    var body: some View {
        List {
            ForEach(metricsLogs, id: \.self) { log in
                
                HStack {
                    
                    
                    VStack (alignment: .leading){
                        
                        
                        Text("\(log.logDate.formatted(date:.complete, time:.omitted))")
                            .foregroundStyle(Color("Sec"))
                            .font(.systemSemiBold(17))
                        
                        VStack(alignment: .leading) {
                            Text("Sleep: \(String(format: "%.2f", log.sleep))") // round to 2dp
                            
                            Text("Activity: \(String(format: "%.2f", log.activity))")
                            
                            Text("Diet: \(String(format: "%.2f", log.diet))")
                            
                            Text("Work: \(String(format: "%.2f", log.work))")
                            
                            Text("\(String(log.journal))")
                            
                        }
                        .foregroundStyle(Color("Sec"))
                    }
                    
                    Spacer() // to align the button
                    
                    Button() {
                        context.delete(log)
                        
                        let summaryLogToBeDeleted: [summaryLog] = allSummaryLogs.filter { Calendar.current.startOfDay(for: log.logDate) <= $0.logDate && $0.logDate <  Calendar.current.startOfDay(for: log.logDate.addingTimeInterval(86400))
                        }
                        if summaryLogToBeDeleted.count > 0 { // if log exists
                            
                            context.delete(summaryLogToBeDeleted[0])
                            
                        }
                        
                    } label: {
                        Image(systemName:"minus.circle.fill")
                        
                    }
                    .tint(Color("Delete"))
                    .buttonStyle(.bordered)
                    
                }
                .listRowBackground(Color("Tint"))
                .font(.system(17))
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(Color("Prim"))
        
    }
}


