

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
                                SleepDatePickerView(viewModel: viewModel)
                            } label: {
                                FactorsTile(chosenFactor: "Sleep")
                            }
                            
                            NavigationLink {
                                SleepDatePickerView(viewModel: viewModel)
                            } label: {
                                FactorsTile(chosenFactor: "Activity")
                            }
                            
                            NavigationLink {
                                SleepDatePickerView(viewModel: viewModel)
                            } label: {
                                FactorsTile(chosenFactor: "Diet")
                            }
                            
                            NavigationLink {
                                SleepDatePickerView(viewModel: viewModel)
                            } label: {
                                FactorsTile(chosenFactor: "Work")
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
                    
                    
                } // ZStack
            } // Navigation Stack
        }
        
    } // body
    
} // PageOneView


// Top bar
struct HomeNavBarView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    var body: some View {
        HStack(spacing:0) { // https://programming-sansho.com/swift/swiftui-spacer/
            
            Spacer()
            
            NavigationLink {
                SettingsView(viewModel: viewModel)
            } label: {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(Color("Prim"))
            }
            
            Spacer()
            
            Text("Hello, \(viewModel.name)") // I feel like this is not exactly centered
                .fontWeight(.heavy)
                .font(.system(24))
                .foregroundStyle(Color("Prim"))
            
            Spacer()
            
            
            
            NavigationLink {
                //SettingsView(viewModel: viewModel)
            } label: {
                Image(systemName: "tray.fill")
                    .foregroundStyle(Color("Prim"))
            }
            
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
                
                if !stressLog.getStressAvg(dayStressLogs: todaysLogs).isNaN { // If data available for selected day
                    
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


struct FactorsTile: View {
    @Query var todaysLog: [dailyFactorsLog]
    var chosenFactor: String

    
    init (chosenFactor: String) {
        var descriptor: FetchDescriptor<dailyFactorsLog> {
            var descriptor = FetchDescriptor<dailyFactorsLog>(predicate: dailyFactorsLog.dayLog(date:Date.now))
            descriptor.fetchLimit = 1
            return descriptor
        }
        
        _todaysLog = Query(descriptor)
        self.chosenFactor = chosenFactor
        
    }
    
    var factorsStats:[String:Double] { // Computed property that summarizes the stat for today
        if todaysLog.count != 0 {
            return ["Sleep": todaysLog[0].sleep, "Activity": todaysLog[0].activity, "Diet": todaysLog[0].diet, "Work": todaysLog[0].work]
        } else {
            return [:] // returns empty dictionary
        }
    }
    
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("\(chosenFactor)")
                    .font(.system(20))
                
                Divider()
                    .overlay(Color("Sec"))
                
                if let stat = factorsStats[chosenFactor] {
                    
                    if chosenFactor == "Sleep" { // for sleep tile, add "h" after the stat to indicate that it's number of hours.
                        
                        Text("\(String(format: "%.2f", stat))h")
                    
                    } else {
                        Text("\(String(format: "%.2f", stat))") // todaysLogs[0]... are optional, so we need to provide a default value after ??
                    }
                    
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

