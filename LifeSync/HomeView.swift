

import SwiftUI
import Charts
import SwiftData
import Foundation
import UserNotifications


struct HomeView: View {
    
    @ObservedObject var viewModel: JournalViewModel
    
    @Environment(\.modelContext) private var context
    
    @State var isInserted = false
    
    var body: some View {
        
        //https://www.youtube.com/watch?app=desktop&v=dRdguneAh8M
        
        NavigationStack {
            
            ZStack {
                
                Color("Prim")
                    .ignoresSafeArea()// Background
                
                VStack {
                    
                    HomeNavBarView(viewModel: viewModel)
                    
                    Divider()
                        .overlay(Color("Sec"))
                    
                    //https://zenn.dev/usk2000/articles/68c4c1ec7944fe
                    
                    ScrollView {
                        LazyVGrid(columns:[GridItem(.adaptive(minimum:160))]) {
                            
                            NavigationLink {
                                StressDatePickerView(viewModel: viewModel)
                            } label: {
                                StressTileView()
                            }
                            
                            
                            // Navigationlinks for metrics
                            ForEach(viewModel.metrics, id:\.self) { metric in
                                
                                NavigationLink {
                                    metricDatePickerView(viewModel: viewModel, metric: metric)
                                } label: {
                                    metricsTileView(chosenmetric: metric) // lowercase for subscript.
                                }
                                
                            }
                            
                            NavigationLink {
                                CorrelationAnalysisView(viewModel: viewModel)
                            } label: {
                                CorrelationTileView()
                            }
                            
                        } // ScrollView
                        
                        
                    } // VStack
                    .foregroundStyle(.white)
                    .padding(15)
                    
                } // VStack
            } // ZStack
            
        } //NavigationStack
        .onAppear() {
            // TODO: delete later
            
            if isInserted == false {
                
                let testLogs = [
                    stressLog(logDate: Date(), stressLevel: 5, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*1), stressLevel: 7, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*2), stressLevel: 3, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*3), stressLevel: 3, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*4), stressLevel: 8, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*5), stressLevel: 6, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*6), stressLevel: 5, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*7), stressLevel: 1, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*8), stressLevel: 10, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*9), stressLevel: 8, notes: "", id: UUID().uuidString),
                    stressLog(logDate: Date().addingTimeInterval(-86400*10), stressLevel: 3, notes: "", id: UUID().uuidString),
                    
                ]
                
                let date = Date()
                
                let testLogs2 = [
                    metricsLog(sleep: 3, activity: 5, diet: 4, work: 5, journal: "", logDate: date),
                    metricsLog(sleep: 5, activity: 5, diet: 2, work: 7, journal: "", logDate: date.addingTimeInterval(-86400*1)),
                    metricsLog(sleep: 7, activity: 3, diet: 5, work: 1, journal: "", logDate: date.addingTimeInterval(-86400*2)),
                    metricsLog(sleep: 1, activity: 8, diet: 8, work: 4, journal: "", logDate: date.addingTimeInterval(-86400*3)),
                    metricsLog(sleep: 10, activity: 3, diet: 5, work: 8, journal: "", logDate: date.addingTimeInterval(-86400*4)),
                    metricsLog(sleep: 4, activity: 3, diet: 2, work: 6, journal: "", logDate: date.addingTimeInterval(-86400*5)),
                    metricsLog(sleep: 5, activity: 7, diet: 8, work: 4, journal: "", logDate: date.addingTimeInterval(-86400*6)),
                    metricsLog(sleep: 5, activity: 7, diet: 8, work: 2, journal: "", logDate: date.addingTimeInterval(-86400*7)),
                    
                ]
                
                for testLog in testLogs2 {
                    context.insert(testLog)
                }
                
                for testLog in testLogs {
                    context.insert(testLog)
                }
                
            }
            
            isInserted = true

            //
        }
        
    } // body
    
} // HomeView


// Top bar
struct HomeNavBarView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    var body: some View {
        HStack(spacing:0) { // https://programming-sansho.com/swift/swiftui-spacer/
            
            Spacer()
            
            Text("Hello, \(viewModel.name)")
                .font(.systemSemiBold(24))
                .foregroundStyle(Color("Sec"))
            
            Spacer()
            
            
        } // HStack
        .frame(maxWidth: .infinity)
    }
}

struct StressTileView: View {
    @Query(filter: stressLog.dayLog(date:Date.now)) var todaysLogs: [stressLog]
    
    var body: some View {
        ZStack {
            // make local variable to avoid repetition
            VStack {
                Text("Stress")
                    .font(.systemSemiBold(20))
                
                Divider()
                    .overlay(Color("Prim"))
                
                if todaysLogs.count > 0 { // If data available for selected day
                    
                    let avgStressString = String(format: "%.2f", stressLog.getStressAvg(dayStressLogs: todaysLogs))
                    
                    Text("\(avgStressString)")
                        .font(.system(27))
                    
                } else {
                    Text("No Data")
                        .font(.system(27))
                }
            }
        } // ZStack
        .padding(35)
        .background(Color("Tint"))
        .aspectRatio(1, contentMode:.fit)
        .clipShape(.rect(cornerRadius: 20))
        .foregroundStyle(Color("Sec"))
    }
}


struct metricsTileView: View {
    @Query(filter: metricsLog.dayLog(date:Date.now)) var todaysLog: [metricsLog]
    var chosenmetric: String
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("\(chosenmetric)")
                    .font(.systemSemiBold(20))

                Divider()
                    .overlay(Color("Prim"))
                
                if todaysLog.count > 0 {
                    
                    Text("\(String(format: "%.2f", todaysLog[0][chosenmetric]))")
                    
                } else {
                    
                    Text("No Data")
                    
                }
                
            }
            .font(.system(27))
            
        } // ZStack
        .padding(35)
        .background(Color("Tint"))
        .aspectRatio(1, contentMode:.fit)
        .clipShape(.rect(cornerRadius: 20))
        .foregroundStyle(Color("Sec"))
    }
}


struct CorrelationTileView: View {
    
    var body: some View {
        ZStack {
            // make local variable to avoid repetition
            VStack {
                Text("Correlation")
                    .font(.systemSemiBold(20))

                Divider()
                    .overlay(Color("Prim"))
                
                Text("Analysis")
                    .font(.system(27))
                
            }
        } // ZStack
        .padding(35)
        .background(Color("Tint"))
        .aspectRatio(1, contentMode:.fit)
        .clipShape(.rect(cornerRadius: 20))
        .foregroundStyle(Color("Sec"))
    }
}

