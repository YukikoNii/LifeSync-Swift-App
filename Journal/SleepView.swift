
import SwiftUI
import Charts
import SwiftData
import Foundation

struct SleepDatePickerView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @State var selectedDay = Date()
    @State var page = 0
    
    var body: some View {
        
        let endDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400*1))
        let startDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(-86400*6))
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            VStack {
                
                HStack {
                    
                    Text("Week")
                        .padding()
                        .background(page == 0 ? Color("Tint") : Color("Sec"))
                        .foregroundColor(page == 0 ? Color("Prim") : Color("Prim"))
                        .clipShape(.rect(cornerRadius:5))
                        .onTapGesture {
                            page = 0
                        }
                    
                    Text("Month")
                        .padding()
                        .background(page == 1 ? Color("Tint") : Color("Sec"))
                        .foregroundColor(page == 1 ? Color("Prim") : Color("Prim"))
                        .clipShape(.rect(cornerRadius:5))
                        .onTapGesture {
                            page = 1
                        }
                }
                .font(.system(17))
                
                
                DatePicker("", selection: $selectedDay, displayedComponents: [.date])
                    .labelsHidden()
                    .padding()
                    .tint(Color("Sec"))
                
                TabView(selection: $page) { // Using TabView as a work around for Dynamic Query
                    SleepView(startDate: startDate, endDate: endDate)
                        .tag(0)
                }
            } // VStack
        } //ZStack
    }
}

struct SleepView: View {
    
    //@ObservedObject var viewModel: JournalViewModel
    // TODO: didn't know how to initalize this, so commented out for now.
    
    @Query var thisWeekSleepLogs: [dailyFactorsLog]
    @Query var lastWeekSleepLogs: [dailyFactorsLog]
    
    init(startDate: Date, endDate: Date) {
        
        let weekBefore = startDate.addingTimeInterval(-86400*7)
        
        let thisWeekPredicate = #Predicate<dailyFactorsLog> {
            startDate < $0.logDate &&
            $0.logDate < endDate
        }
        
        let lastWeekPredicate = #Predicate<dailyFactorsLog> {
            weekBefore < $0.logDate &&
            $0.logDate < startDate
            
        }
        
        _thisWeekSleepLogs = Query(filter: thisWeekPredicate, sort: \.logDate)
        _lastWeekSleepLogs = Query(filter: lastWeekPredicate, sort: \.logDate)
    }
    
    
    var body: some View {
        
        //var dailyAverage = log.getStressAvg(dayStressLogs: logs)
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            ScrollView {
                if thisWeekSleepLogs.count != 0 { // if data exists for this week
                    
                    Chart {
                        
                        ForEach(thisWeekSleepLogs) { log in
                            LineMark(
                                x: .value("Date", log.logDate),
                                y: .value("Stress", log.sleep)
                            )
                            .interpolationMethod(.catmullRom)
                            .symbol(.square)
                            .foregroundStyle(Color("Prim"))
                            .offset(x:10)
                            
                        } // ForEach
                        
                        
                    } // Chart
                    .chartYAxis {
                        
                        AxisMarks(
                            values: [0, 5, 10]
                        ) {
                            AxisValueLabel()
                                .foregroundStyle(Color("Prim")) // change the color for  readability
                                .font(.system(10))
                        }
                        
                        AxisMarks(
                            values: [1, 2, 3, 4, 6, 7, 8, 9]
                        ) {
                            AxisGridLine()
                                .foregroundStyle(Color("Prim"))
                        }
                        
                    }
                    .chartScrollableAxes(.horizontal) // https://swiftwithmajid.com/2023/07/25/mastering-charts-in-swiftui-scrolling/
                    .chartXVisibleDomain(length: 86400*7) // https://stackoverflow.com/questions/77236097/swift-charts-chartxvisibledomain-hangs-or-crashes (measured in seconds)
                    .chartXAxis {AxisMarks(values: .automatic) {
                        AxisValueLabel()
                            .foregroundStyle(Color("Prim"))
                        
                        AxisGridLine()
                            .foregroundStyle(Color("Prim"))
                    }
                    }
                    .padding(30)
                    .background(Color("Tint"))
                    .clipShape(.rect(cornerRadius: 20))
                    .frame(width:350, height:350)
                    
                } else { // if not
                    
                    Text("No Data")
                }
                
                LazyVGrid(columns:  [GridItem(alignment: .topLeading), GridItem(alignment: .topLeading)]) {
                    
                    FactorsAnalysisView(data: thisWeekSleepLogs, beforeData: lastWeekSleepLogs, duration: "week")
                    
                }// LazyVGrid
                .padding(10)
                .background(Color("Tint"))
                .clipShape(.rect(cornerRadius: 15))
                .frame(width:350)
                
                
            }// ScrollView
            .foregroundStyle(Color("Prim"))
            .font(.system(18))
            .toolbarBackground(Color("Sec"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            
        }//ZStack
        
    } // Body
} // StressView

struct FactorsAnalysisView : View {
    let data:[dailyFactorsLog]
    let beforeData:[dailyFactorsLog]
    let periodInPast = ["week": "last week", "month": "last month"]
    let duration: String // I am not sure if this is correct.
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text("Average:")
                .foregroundStyle(Color("Prim"))
                .font(.system(18))
            
            if !dailyFactorsLog.getSleepAvg(dailyFactorsLogs: data).isNaN { // If data available for selected day
                
                let avgSleepString = String(format: "%.2f", dailyFactorsLog.getSleepAvg(dailyFactorsLogs: data)) // round to 2dp
                
                Text("\(avgSleepString)h")
                    .foregroundStyle(Color("Prim"))
                    .font(.systemSemiBold(20))
            } else {
                Text("No Data")
                    .foregroundStyle(Color("Prim"))
                    .font(.systemSemiBold(20))
                
            }
            
            
        }
        
        VStack (alignment: .leading) {
            
            Text("Trend:")
                .foregroundStyle(Color("Prim"))
                .font(.system(18))
            
            if !dailyFactorsLog.getSleepAvg(dailyFactorsLogs: data).isNaN
                && !dailyFactorsLog.getSleepAvg(dailyFactorsLogs: beforeData).isNaN {  // If data available for both  selected day and day before.
                
                
                Text("\(dailyFactorsLog.calculatePercentage(period1: dailyFactorsLog.getSleepAvg(dailyFactorsLogs: data), period2: dailyFactorsLog.getSleepAvg(dailyFactorsLogs: beforeData))) % compared to \(periodInPast[duration] ?? "last week")")
                    .foregroundStyle(Color("Prim"))
                    .font(.systemSemiBold(20))
                
            } else {
                Text("No Data")
                    .foregroundStyle(Color("Prim"))
                    .font(.systemSemiBold(20))
            }
            
        }
        .foregroundStyle(Color("Prim"))
        .font(.systemSemiBold(20))
        .padding(10)
        // TODO: when your stress level is highest
        
        
    }
}


