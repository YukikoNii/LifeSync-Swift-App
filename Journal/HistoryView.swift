
import SwiftUI
import SwiftData
import Foundation

struct HistoryView: View {
    
    @ObservedObject var viewModel: JournalViewModel
    
    @Query(sort: \dailyFactorsLog.logDate) var dailyFactorsLogs: [dailyFactorsLog]
    @State var index = 0

    var body: some View {
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Text("Stress Logs")
                        .padding()
                        .background(index == 0 ? Color("Var") : Color("Sec"))
                        .foregroundColor(index == 0 ? Color("Prim") : Color("Prim"))
                        .font(.system(17))
                        .clipShape(.rect(cornerRadius:5))
                        .onTapGesture {
                            index = 0
                        }
                    
                    Text("Daily Logs")
                        .padding()
                        .background(index == 1 ? Color("Var") : Color("Sec"))
                        .foregroundColor(index == 1 ? Color("Prim") : Color("Prim"))
                        .font(.system(17))
                        .clipShape(.rect(cornerRadius:5))
                        .onTapGesture {
                            index = 1
                        }
                }
                
                
                TabView(selection: $index) {
                    StressHistoryView(viewModel: viewModel)
                        .tag(0)

                    
                    FactorsHistoryView(viewModel: viewModel)
                        .tag(1)

                } // TabView
            } // VStack
        }//ZStack
    } // body
} // HistoryView



struct StressHistoryView: View {
    @Environment(\.modelContext) private var context

    @ObservedObject var viewModel: JournalViewModel
    @Query(sort: \stressLog.logDate) var stressLogs: [stressLog]

    var body: some View {
        List {
            ForEach(stressLogs) { log in
                VStack (alignment: .leading){
                    HStack {
                        
                        NavigationLink {
                        } label: {
                            Text("\(log.logDate.formatted(date:.abbreviated, time:.shortened))")
                                .foregroundStyle(Color("Prim"))
                        }
                    }
                    VStack {
                        Text("Stress Level: \(String(format: "%.2f", log.stressLevel))") // round to 2dp
                        
                    }
                    .foregroundStyle(Color("Prim"))
                }
                .swipeActions(edge: .trailing) {
                    Button("Delete", role: .destructive) {
                        context.delete(log)
                    }
                    .tint(Color("Delete"))
                }
                .swipeActions(edge: .leading) {
                    Button ("Edit") {
                    }
                    .tint(Color("Edit"))
                }
                .listRowBackground(Color("Var"))
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(Color("Sec"))
        .foregroundStyle(.white)
    }
}

struct FactorsHistoryView: View {
    @Environment(\.modelContext) private var context

    
    @ObservedObject var viewModel: JournalViewModel

    @Query(sort: \dailyFactorsLog.logDate) var dailyFactorsLogs: [dailyFactorsLog]

    var body: some View {
        List {
            ForEach(dailyFactorsLogs, id: \.self) { log in
                VStack (alignment: .leading){
                    HStack {
                        
                        NavigationLink {
                        } label: {
                            Text("\(log.logDate.formatted(date:.abbreviated, time:.shortened))")
                                .foregroundStyle(Color("Prim"))
                        }
                    }
                    VStack {
                        Text("Sleep: \(String(format: "%.2f", log.sleep))") // round to 2dp
                        
                        Text("Activity: \(String(format: "%.2f", log.activity))")
                        
                        Text("Diet: \(String(format: "%.2f", log.diet))")
                        
                        Text("Work: \(String(format: "%.2f", log.work))")
                        
                        Text("\(String(log.journal))")
                        
                    }
                    .foregroundStyle(Color("Prim"))
                }
                .swipeActions(edge: .trailing) {
                    Button("Delete", role: .destructive) {
                        context.delete(log)
                    }
                    .tint(Color("Delete"))
                }
                .swipeActions(edge: .leading) {
                    Button ("Edit") {
                    }
                    .tint(Color("Edit"))
                }
                .listRowBackground(Color("Var"))
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(Color("Sec"))
        .foregroundStyle(.white)
        .tag(1)
    }
}
