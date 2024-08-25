
import SwiftUI
import SwiftData
import Foundation

struct HistoryView: View {
    
    @ObservedObject var viewModel: JournalViewModel
    
    @Query(sort: \dailyFactorsLog.logDate) var dailyFactorsLogs: [dailyFactorsLog]
    @State var page = 0

    var body: some View {
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Text("Stress Log")
                        .padding()
                        .background(page == 0 ? Color("Tint") : Color("Sec"))
                        .foregroundColor(page == 0 ? Color("Prim") : Color("Prim"))
                        .font(.system(17))
                        .clipShape(.rect(cornerRadius:5))
                        .onTapGesture {
                            page = 0
                        }
                    
                    Text("Factors Log")
                        .padding()
                        .background(page == 1 ? Color("Tint") : Color("Sec"))
                        .foregroundColor(page == 1 ? Color("Prim") : Color("Prim"))
                        .font(.system(17))
                        .clipShape(.rect(cornerRadius:5))
                        .onTapGesture {
                            page = 1
                        }
                }
                
                TabView(selection: $page) {
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
                    VStack(alignment: .leading) {
                        Text("Stress Level: \(String(format: "%.2f", log.stressLevel))") // round to 2dp
                        Text("\(String(log.notes))")
                        
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
                .listRowBackground(Color("Tint"))
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(Color("Sec"))
        .foregroundStyle(.white)
        .toolbarBackground(Color("Sec"), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
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
                    VStack(alignment: .leading) {
                        Text("Sleep: \(String(format: "%.2f", log.sleep))") // round to 2dp TODO: 
                        
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
                .listRowBackground(Color("Tint"))
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(Color("Sec"))
        .foregroundStyle(.white)
        .toolbarBackground(Color("Sec"), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
