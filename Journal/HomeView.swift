

import SwiftUI
import Charts
import SwiftData
import Foundation
import UserNotifications


struct HomeView: View {
    
    @ObservedObject var viewModel: JournalViewModel
    
    var body: some View {
        
        //https://www.youtube.com/watch?app=desktop&v=dRdguneAh8M
        
        NavigationStack {
            
            ZStack {
                
                Color("Sec")
                    .ignoresSafeArea()// Background
                
                VStack {
                    
                    HomeNavBarView(viewModel: viewModel)
                    
                    Divider()
                        .overlay(Color("Prim"))
                    
                    //https://zenn.dev/usk2000/articles/68c4c1ec7944fe
                    
                    ScrollView {
                        LazyVGrid(columns:[GridItem(.adaptive(minimum:160))]) {
                            
                            NavigationLink {
                                StressDatePickerView(viewModel: viewModel)
                            } label: {
                                StressTileView()
                            }
                            
                            NavigationLink {
                                FactorDatePickerView(viewModel: viewModel, factor: "sleep")
                            } label: {
                                FactorsTileView(chosenFactor: "sleep") // lowercase for subscript. 
                            }
                            
                            NavigationLink {
                                FactorDatePickerView(viewModel: viewModel, factor: "activity")
                            } label: {
                                FactorsTileView(chosenFactor: "activity")
                            }
                            
                            NavigationLink {
                                FactorDatePickerView(viewModel: viewModel, factor: "diet")
                            } label: {
                                FactorsTileView(chosenFactor: "diet")
                            }
                            
                            NavigationLink {
                                FactorDatePickerView(viewModel: viewModel, factor:  "work")
                            } label: {
                                FactorsTileView(chosenFactor: "work")
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
            UITabBar.appearance().unselectedItemTintColor = .white
            
            for index in 0...2 { // produce three notifications
                if viewModel.isStressLogsRemindersOn[index] {
                    let components = Calendar.current.dateComponents(in: TimeZone.current, from: viewModel.stressLogsReminderTime[index])
                    
                    setNotification(hour: components.hour!, minute: components.minute!, identifier: String(index)) // trigger notification
                                        
                }
                
            }
            //https://llcc.hatenablog.com/entry/2017/08/31/230000
        }
        
    } // body
    
} // PageOneView


// Top bar
struct HomeNavBarView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    var body: some View {
        HStack(spacing:0) { // https://programming-sansho.com/swift/swiftui-spacer/
            
            Spacer()
            
            Text("Hello, \(viewModel.name)") 
                .fontWeight(.heavy)
                .font(.system(24))
                .foregroundStyle(Color("Prim"))
            
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
                    .font(.system(20))
                
                Divider()
                    .overlay(Color("Sec"))
                
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
        .foregroundStyle(Color("Prim"))
    }
}


struct FactorsTileView: View {
    @Query(filter: dailyFactorsLog.dayLog(date:Date.now)) var todaysLog: [dailyFactorsLog]
    var chosenFactor: String

    var body: some View {
        
        ZStack {
            VStack {
                Text("\(chosenFactor)")
                    .font(.system(20))
                
                Divider()
                    .overlay(Color("Sec"))
                
                if todaysLog.count > 0 {
                    
                    Text("\(String(format: "%.2f", todaysLog[0][chosenFactor]))") 
                    
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
        .foregroundStyle(Color("Prim"))
    }
}


struct CorrelationTileView: View {
    
    var body: some View {
        ZStack {
            // make local variable to avoid repetition
            VStack {
                Text("Correlation")
                    .font(.system(20))
                
                Divider()
                    .overlay(Color("Sec"))
                
                Text("Analysis")
                    .font(.system(27))
                
            }
        } // ZStack
        .padding(35)
        .background(Color("Tint"))
        .aspectRatio(1, contentMode:.fit)
        .clipShape(.rect(cornerRadius: 20))
        .foregroundStyle(Color("Prim"))
    }
}

