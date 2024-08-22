

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

                    /*Button {
                     Task {
                     await notification()
                     }
                     } label: {
                     Text("Push!")
                     } */
                    
                    HomeNavBarView(viewModel: viewModel)
                    
                    Divider()
                        .overlay(Color("Prim"))
                    
                    /*
                     ScrollView(.horizontal) {
                     HStack {
                     
                     Text("Overview")
                     .padding()
                     .background(index == 0 ? Color("Sec") : Color("Prim"))
                     .foregroundColor(index == 0 ? Color("Prim") : Color("Sec"))
                     .font(.system(18))
                     .clipShape(.rect(cornerRadius:20))
                     
                     .onTapGesture {
                     index = 0
                     }
                     
                     ForEach(overviewTiles, id: \.self) { indicator in
                     
                     Text(indicator.name)
                     .padding()
                     .background(index == indicator.id + 1 ? Color("Sec") : Color("Prim"))
                     .foregroundColor(index == indicator.id + 1 ? Color("Prim") : Color("Sec"))
                     .tint(.black)
                     .font(.system(18))
                     .clipShape(.rect(cornerRadius:20))
                     
                     .onTapGesture {
                     
                     index = indicator.id + 1
                     }
                     }
                     
                     // TODO: Will probably remove this later.
                     Text("Analysis")
                     .padding()
                     .background(index == 5 ? Color.black : Color("Prim"))
                     .foregroundColor(.white)
                     .tint(.black)
                     .font(.system(18))
                     .onTapGesture {
                     
                     index = 5
                     }
                     }
                     }
                     
                     Divider()
                     .overlay(Color("Sec"))
                     
                     */
                    
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
                                SleepTileView()
                            }
                            
                            
                            NavigationLink {
                                CorrelationAnalysisView(viewModel: viewModel)
                            } label: {
                                CorrelationTileView()
                            }
                            
                            
                            /*
                             ForEach(overviewTiles, id: \.self) { indicator in
                             
                             ZStack {
                             // make local variable to avoid repetition
                             VStack {
                             Text(indicator.name)
                             .font(.system(20))
                             
                             Divider()
                             .overlay(Color("Sec"))
                             
                             Text(indicator.stat)
                             .font(.system(27))
                             }
                             } // ZStack
                             .padding(35)
                             .background(Color("Prim"))
                             .aspectRatio(1, contentMode:.fit)
                             .clipShape(.rect(cornerRadius: 20))
                             .foregroundStyle(Color("Sec"))
                             }
                             }
                             */
                            // LazyVGrid
                        } // ScrollView
                        
                    } // VStack
                    .foregroundStyle(.white)
                    .padding(15)
                    
                    
                } // ZStack
            } // Navigation Stack
        }
        .onAppear {
            notification ()
        }

    } // body
        
    
    /*
    struct Indicator: Identifiable, Hashable {
        
        var name:String
        var stat: String
        var id = UUID()

    }
    
    var overviewTiles = [
        Indicator(name: "Sleep", stat: "8h 30m"),
        Indicator(name: "Exercise", stat: "30m"),
        Indicator(name: "Diet", stat: "Poor"),
        Indicator(name: "Work", stat: "Stressed"),
    ]
     */
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
        .background(Color("Var"))
        .aspectRatio(1, contentMode:.fit)
        .clipShape(.rect(cornerRadius: 20))
        .foregroundStyle(Color("Prim"))
    }
}

struct SleepTileView: View {
    @Query(filter: dailyFactorsLog.dayLog(date:Date.now)) var todaysLog: [dailyFactorsLog]

    var body: some View {
        ZStack {
            // make local variable to avoid repetition
            VStack {
                Text("Sleep")
                    .font(.system(20))
                
                Divider()
                    .overlay(Color("Sec"))
                
                if todaysLog.count != 0 { // If there is log for today
                    
                    ForEach(todaysLog) { log in
                        
                        Text("\(String(format: "%.2f", log.sleep))h")
                            .font(.system(27))
                        
                    }// ForEach
                    
                } else {
                    Text("No Data")
                        .font(.system(27))
                }
                
            }
        } // ZStack
        .padding(35)
        .background(Color("Var"))
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
        .background(Color("Var"))
        .aspectRatio(1, contentMode:.fit)
        .clipShape(.rect(cornerRadius: 20))
        .foregroundStyle(Color("Prim"))
    }
}

