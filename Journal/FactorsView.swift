
import SwiftUI
import Charts
import SwiftData
import Foundation

struct FactorDatePickerView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @State var selectedDay = Date()
    @State var page = "week"
    var factor: String
    
    var body: some View {
        
        let endDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400*1))
        let weekStartDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(-86400*7))
        let monthStartDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            VStack {
                
                TimeSpanPicker(page: $page)
                
                
                HStack {
                    
                    if page == "week" {
                        
                        Text(weekStartDate, format: .dateTime.day().month().year())
                        Text(" to")
                        
                    } else if page == "month" {
                        
                        Text(monthStartDate, format: .dateTime.day().month().year())
                        Text(" to")
                        
                    }
                    
                    DatePicker("", selection: $selectedDay, displayedComponents: [.date])
                        .labelsHidden()
                        .padding()
                        .tint(Color("Sec"))
                    
                }
                .foregroundStyle(Color("Prim"))
                .font(.system(18))
                
                TabView(selection: $page) { // Using TabView as a work around for Dynamic Query
                    WeekView(startsOn: weekStartDate, endsOn: endDate, factor: factor)
                        .tag("week")
                    MonthView(startsOn: monthStartDate, endsOn: endDate, factor: factor)
                        .tag("month")
                    
                }
            } // VStack
        } //ZStack
    }
}

struct WeekView: View {
    
    //@ObservedObject var viewModel: JournalViewModel
    // TODO: didn't know how to initalize this, so commented out for now.
    var factor: String
    
    @Query var thisWeekLogs: [dailyFactorsLog]
    @Query var lastWeekLogs: [dailyFactorsLog]
    
    init(startsOn startDate: Date, endsOn endDate: Date, factor: String) {
        
        let weekBefore = startDate.addingTimeInterval(-86400*7)
        
        let thisWeekPredicate = #Predicate<dailyFactorsLog> {
            startDate < $0.logDate &&
            $0.logDate < endDate
        }
        
        let lastWeekPredicate = #Predicate<dailyFactorsLog> {
            weekBefore < $0.logDate &&
            $0.logDate < startDate
            
        }
        
        _thisWeekLogs = Query(filter: thisWeekPredicate, sort: \.logDate)
        _lastWeekLogs = Query(filter: lastWeekPredicate, sort: \.logDate)
        self.factor = factor
    }
    
    
    var body: some View {
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            ScrollView {
                if thisWeekLogs.count != 0 { // if data exists for this week
                    
                    Chart {
                        
                        ForEach(thisWeekLogs) { log in
                            LineMark(
                                x: .value("Date", log.logDate),
                                y: .value("Stress", log[factor])
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
                                .foregroundStyle(Color("Prim"))
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
                    
                    FactorsAnalysisView(factor: factor, data: thisWeekLogs, beforeData: lastWeekLogs, duration: "week")
                    
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

struct MonthView: View {
    
    //@ObservedObject var viewModel: JournalViewModel
    // TODO: didn't know how to initalize this, so commented out for now.
    
    var factor: String
    
    @Query var thisMonthLogs: [dailyFactorsLog]
    @Query var lastMonthLogs: [dailyFactorsLog]
    var numOfDaysInMonth: Int

    
    init(startsOn startDate: Date, endsOn endDate: Date, factor: String) {
        let monthBefore = Calendar.current.date(byAdding: .month, value: -1, to: startDate)!
            
        let thisMonthPredicate = #Predicate<dailyFactorsLog> {
            startDate < $0.logDate &&
            $0.logDate <= endDate
        }
        
        let lastMonthPredicate = #Predicate<dailyFactorsLog> {
            monthBefore < $0.logDate &&
            $0.logDate <= startDate
            
        }
        
        _thisMonthLogs = Query(filter: thisMonthPredicate, sort: \.logDate)
        _lastMonthLogs = Query(filter: lastMonthPredicate, sort: \.logDate)
        numOfDaysInMonth = Calendar.current.numOfDaysInBetween(from: startDate, to: endDate)
        self.factor = factor

    }
    
    var body: some View {
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            ScrollView {
                if thisMonthLogs.count != 0 { // if data exists for this week
                    
                    Chart {
                        
                        ForEach(thisMonthLogs) { log in
                            LineMark(
                                x: .value("Date", log.logDate),
                                y: .value("Stress", log[factor])
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
                                .foregroundStyle(Color("Prim"))
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
                    .chartXVisibleDomain(length: 86400*numOfDaysInMonth) // https://stackoverflow.com/questions/77236097/swift-charts-chartxvisibledomain-hangs-or-crashes (measured in seconds)
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
                    
                    FactorsAnalysisView(factor: factor, data: thisMonthLogs, beforeData: lastMonthLogs, duration: "month")
                    
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
    let factor: String
    let data:[dailyFactorsLog]
    let beforeData:[dailyFactorsLog]
    var maxData: [dailyFactorsLog] {
            return data.sorted { $0[factor] > $1[factor]}
    }
    
    init(factor: String, data: [dailyFactorsLog], beforeData: [dailyFactorsLog], duration: String) {
        self.factor = factor
        self.data = data
        self.beforeData = beforeData
        self.duration = duration
    }
    
    
    let periodInPast = [ "week": "last week", "month": "last month"]
    let duration: String // I am not sure if this is correct.
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text("Average:")
                .foregroundStyle(Color("Prim"))
                .font(.system(18))
            
            if !dailyFactorsLog.getAvg(dailyFactorsLogs: data, factor: "sleep").isNaN { // If data available for selected day
                
                let avgSleepString = String(format: "%.2f", dailyFactorsLog.getAvg(dailyFactorsLogs: data, factor: "sleep")) // round to 2dp
                
                Text("\(avgSleepString)h")
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
        
        VStack (alignment: .leading) {
            
            Text("Trend:")
                .foregroundStyle(Color("Prim"))
                .font(.system(18))
            
            if !dailyFactorsLog.getAvg(dailyFactorsLogs: data, factor: "sleep").isNaN
                && !dailyFactorsLog.getAvg(dailyFactorsLogs: beforeData, factor: "sleep").isNaN {  // If data available for both selected day and day before.
                
                Text("\(dailyFactorsLog.calculatePercentage(numerator: dailyFactorsLog.getAvg(dailyFactorsLogs: data, factor: "sleep"), dividedBy: dailyFactorsLog.getAvg(dailyFactorsLogs: beforeData, factor: "sleep"))) % compared to \(periodInPast[duration] ?? "last week")")
                    .foregroundStyle(Color("Prim"))
                
            } else {
                Text("No Data")
                    .foregroundStyle(Color("Prim"))
            }
            
        }
        .foregroundStyle(Color("Prim"))
        .font(.systemSemiBold(20))
        .padding(10)
        
        VStack(alignment: .leading) {
            
            Text("Maximum:")
                .font(.system(18))
            
            if maxData.count != 0 {
                                
                Text("\(String(format: "%.2f", maxData[0][factor])) on")
                Text(maxData[0].logDate, format: .dateTime.day().month().weekday()) // show date and weekday
                
            } else {
                Text("No Data")
            }
        }
        .foregroundStyle(Color("Prim"))
        .font(.systemSemiBold(20))
        .padding(10)
        
    }
}




struct TimeSpanPicker: View {
    @Binding var page: String
    
    var body: some View {
        HStack {
            
            Text("Week")
                .padding()
                .background(page == "week" ? Color("Tint") : Color("Sec"))
                .foregroundColor(page == "week" ? Color("Prim") : Color("Prim"))
                .clipShape(.rect(cornerRadius:5)) // ios 13.0+
                .onTapGesture {
                    page = "week"
                }
            
            Text("Month")
                .padding()
                .background(page == "month" ? Color("Tint") : Color("Sec"))
                .foregroundColor(page == "month" ? Color("Prim") : Color("Prim"))
                .clipShape(.rect(cornerRadius:5))
                .onTapGesture {
                    page = "month"
                }
        }
        .font(.system(17))
    }
}
