

import SwiftUI
import Charts
import SwiftData
import Foundation

struct PageOneView: View {
    
    @ObservedObject var viewModel: JournalViewModel
    
    @Environment(\.modelContext) private var context
    @Query var logs: [stressLog]
    @Query(filter: stressLog.dayLog(date:Date.now)) var todaysLogs: [stressLog]
    
    
    @State var index = 0

    var body: some View {
        
    //https://www.youtube.com/watch?app=desktop&v=dRdguneAh8M
        
        NavigationStack {
            
            ZStack {
                
                Color("Prim")
                    .ignoresSafeArea()// Background
                
                VStack {
                    
                    HStack(spacing:0) { // https://programming-sansho.com/swift/swiftui-spacer/
                        
                        NavigationLink {
                            PageThreeView(viewModel: viewModel)
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(Color("Sec"))
                        }
                        
                        
                        Spacer()
                        
                        Text("Hello, \(viewModel.name)") // I feel like this is not exactly centered
                            .fontWeight(.heavy)
                            .font(.system(30))
                            .foregroundStyle(Color("Sec"))
                        
                        Spacer()
                        
                    } // HStack
                    .frame(maxWidth:.infinity)
                    
                    Divider()
                        .overlay(Color("Sec"))
                    
                    
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
                    
                    //https://zenn.dev/usk2000/articles/68c4c1ec7944fe
                    
                    TabView (selection: $index) {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(), GridItem()]) {
                                
                                ZStack {
                                    // make local variable to avoid repetition
                                    VStack {
                                        Text("Stress")
                                            .font(.system(20))
                                        
                                        Divider()
                                            .overlay(Color("Prim"))
                                        
                                        Text(stressLog.getStressAvg(dayStressLogs: todaysLogs).isNaN ?  "No Data" : "\(stressLog.getStressAvg(dayStressLogs: todaysLogs))/10")
                                            .font(.system(27))
                                    }
                                } // ZStack
                                .padding(35)
                                .background(Color("Sec"))
                                .aspectRatio(1, contentMode:.fit)
                                .clipShape(.rect(cornerRadius: 20))
                                .foregroundStyle(Color("Prim"))
                                
                                ForEach(overviewTiles, id: \.self) { indicator in
                                    
                                    ZStack {
                                        // make local variable to avoid repetition
                                        VStack {
                                            Text(indicator.name)
                                                .font(.system(20))
                                            
                                            Divider()
                                                .overlay(Color("Prim"))
                                            
                                            Text(indicator.stat)
                                                .font(.system(27))
                                        }
                                    } // ZStack
                                    .padding(35)
                                    .background(Color("Sec"))
                                    .aspectRatio(1, contentMode:.fit)
                                    .clipShape(.rect(cornerRadius: 20))
                                    .foregroundStyle(Color("Prim"))
                                }
                            }
                            .tag(0)// LazyVGrid
                        } // ScrollView
                        
                        StressView(viewModel:viewModel)
                            .tag(1)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    
                } // VStack
                .foregroundStyle(.white)
                .padding(15)
                
                
                
                
            } // ZStack
        } // Navigation Stack
        .onAppear() { // init() didn't work because I didn't know how to initialize viewmodel, so I decided to use onAppear. It's working fine so far.
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tertiary, .font:UIFont.titillium]
            
            // TODO: change the color of the back button:  https://stackoverflow.com/questions/59921239/hide-navigation-bar-without-losing-swipe-back-gesture-in-swiftui#_=_
        }

    } // body
    
    
    
    struct Indicator: Identifiable, Hashable {
        
        var name:String
        var stat: String
        var id: Int

    }

    
    var overviewTiles = [
        Indicator(name: "Stress", stat: "", id:0),
        Indicator(name: "Sleep", stat: "8h 30m", id:1),
        Indicator(name: "Exercise", stat: "30m", id:2),
        Indicator(name: "Diet", stat: "Poor", id:3),
        Indicator(name: "Work", stat: "Stressed", id:4)
    ]
} // PageOneView




