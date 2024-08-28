
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
                
                LogTypePickerView(page: $page)
                
                TabView(selection: $page) {
                    StressHistoryView(viewModel: viewModel)
                        .tag(0)

                    metricsHistoryView(viewModel: viewModel)
                        .tag(1)

                } // TabView
            } // VStack
        }//ZStack
    } // body
} // HistoryView



struct StressHistoryView: View {
    @ObservedObject var viewModel: JournalViewModel

    @Environment(\.modelContext) private var context

    @Query(sort: \stressLog.logDate) var stressLogs: [stressLog]

    var body: some View {
        List {
            ForEach(stressLogs) { log in
                VStack (alignment: .leading){
                    HStack {
                        
                        NavigationLink {
                        } label: {
                            Text("\(log.logDate.formatted(date:.complete, time:.shortened))")
                                .foregroundStyle(Color("Sec"))
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Stress Level: \(String(format: "%.2f", log.stressLevel))") // round to 2dp
                        Text("\(String(log.notes))")
                        
                    }
                    .foregroundStyle(Color("Sec"))
                }
                .swipeActions(edge: .trailing) {
                    Button("Delete", role: .destructive) {
                        context.delete(log)
                        
                        //TODO: need to find a way to delete the summaryLog.

                    }
                    .tint(Color("Delete"))
                }
                .listRowBackground(Color("Tint"))
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(Color("Prim"))
        .foregroundStyle(.white)
        .toolbarBackground(Color("Prim"), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

struct metricsHistoryView: View {
    @ObservedObject var viewModel: JournalViewModel

    @Environment(\.modelContext) private var context

    @Query(sort: \metricsLog.logDate) var metricsLogs: [metricsLog]
    @Query var allmetricsLogs: [metricsLog]
    @Query var allStressLogs: [stressLog]

    var body: some View {
        List {
            ForEach(metricsLogs, id: \.self) { log in
                VStack (alignment: .leading){
                    HStack {
                        
                        NavigationLink {
                        } label: {
                            Text("\(log.logDate.formatted(date:.complete, time:.shortened))")
                                .foregroundStyle(Color("Sec"))
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Sleep: \(String(format: "%.2f", log.sleep))") // round to 2dp 
                        
                        Text("Activity: \(String(format: "%.2f", log.activity))")
                        
                        Text("Diet: \(String(format: "%.2f", log.diet))")
                        
                        Text("Work: \(String(format: "%.2f", log.work))")
                        
                        Text("\(String(log.journal))")
                        
                    }
                    .foregroundStyle(Color("Sec"))
                }
                .swipeActions(edge: .trailing) {
                    Button("Delete", role: .destructive) {
                        context.delete(log)
                        
                        createSummaryLog(metricsLogs: allmetricsLogs, stressLogs: allStressLogs, context: context)

                    }
                    .tint(Color("Delete"))
                }
                .listRowBackground(Color("Tint"))
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(Color("Prim"))
        .foregroundStyle(.white)
        .toolbarBackground(Color("Prim"), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
