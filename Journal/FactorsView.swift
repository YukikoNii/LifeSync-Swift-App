
import SwiftUI
import Charts
import SwiftData
import Foundation

struct metricDatePickerView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @State var selectedDay = Date()
    @State var page = "week"
    var metric: String
    
    var body: some View {
        
        let endDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400*1))
        let weekStartDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(-86400*6))
        let monthStartDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
        
        ZStack {
            
            Color("Prim")
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
                        .tint(Color("Prim"))
                }
                .foregroundStyle(Color("Sec"))
                .font(.system(18))
                
                TabView(selection: $page) { // Using TabView as a work around for Dynamic Query
                    WeekView(startsOn: weekStartDate, endsOn: endDate, metric: metric)
                        .tag("week")
                    MonthView(startsOn: monthStartDate, endsOn: endDate, metric: metric)
                        .tag("month")
                    
                }
            } // VStack
        } //ZStack
    }
}

struct WeekView: View {
    //@ObservedObject var viewModel: JournalViewModel
    // TODO: didn't know how to initalize this, so commented out for now.
    var metric: String
    
    @Query var allLogs: [metricsLog]
    
    @Query var thisWeekLogs: [metricsLog]
    @Query var lastWeekLogs: [metricsLog]
    
    init(startsOn startDate: Date, endsOn endDate: Date, metric: String) {
        
        let weekBefore = startDate.addingTimeInterval(-86400*7)
        
        let thisWeekPredicate = #Predicate<metricsLog> {
            startDate <= $0.logDate &&
            $0.logDate < endDate
        }
        
        let lastWeekPredicate = #Predicate<metricsLog> {
            weekBefore <= $0.logDate &&
            $0.logDate < startDate
            
        }
        
        _thisWeekLogs = Query(filter: thisWeekPredicate, sort: \.logDate)
        _lastWeekLogs = Query(filter: lastWeekPredicate, sort: \.logDate)
        self.metric = metric
    }
    
    
    var body: some View {
        
        ZStack {
            
            Color("Prim")
                .ignoresSafeArea()// Background
            
            ScrollView {
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]) {
                    
                    if thisWeekLogs.count > 0 { // if data exists for this week
                        
                        Chart {
                            
                            ForEach(thisWeekLogs) { log in
                                LineMark(
                                    x: .value("Date", log.logDate),
                                    y: .value("Stress", log[metric])
                                )
                                .interpolationMethod(.linear)
                                .symbol(.square)
                                .foregroundStyle(Color("Sec"))
                                
                            } // ForEach
                            
                            
                        } // Chart
                        .chartYAxis {
                            
                            AxisMarks(
                                values: [0, 5, 10]
                            ) {
                                AxisValueLabel()
                                    .foregroundStyle(Color("Sec"))
                                    .font(.system(10))
                            }
                            
                            AxisMarks(
                                values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            ) {
                                AxisGridLine()
                                    .foregroundStyle(Color("Sec"))
                            }
                            
                        }
                        .chartXVisibleDomain(length: 86400*7) // https://stackoverflow.com/questions/77236097/swift-charts-chartxvisibledomain-hangs-or-crashes (measured in seconds)
                        .chartXAxis {
                            
                            AxisMarks(
                                preset: .aligned, position: .bottom, // src: https://stackoverflow.com/questions/78861139/how-to-fix-leading-and-trailing-x-axis-label-truncation-in-swift-chart
                                values: .stride(by:.day, count:1), content:
                            {
                                AxisValueLabel(format: .dateTime.weekday().day()) // TODO: it somehow doesn't show the last date, looks like I need to crate chartXAxis values manually
                                    .foregroundStyle(Color("Sec"))
                                
                                AxisGridLine()
                                    .foregroundStyle(Color("Sec"))
                            })

                            
                        }
                        .padding(30)
                        .background(Color("Tint"))
                        .clipShape(.rect(cornerRadius: 20))
                        .frame(width:350, height:350)
                        .chartXScale(range: .plotDimension(padding: 10))
                        .chartYScale(domain: 0 ... 10, range: .plotDimension(padding: 10)) // added this so that the y-axis marks are not reversed even when data is 0.
                        
                        
                    } else { // if no data
                        
                        Text("No Data")
                    }
                    
                    LazyVGrid(columns:  [GridItem(alignment: .topLeading), GridItem(alignment: .topLeading)]) {
                        
                        metricsAnalysisView(metric: metric, data: thisWeekLogs, beforeData: lastWeekLogs, duration: "week")
                        
                    }// LazyVGrid
                    .padding(10)
                    .background(Color("Tint"))
                    .clipShape(.rect(cornerRadius: 15))
                    .frame(width:350)
                    
                    metricWeekdayBarChart(data: allLogs, metric: metric)
                    
                }
                
                
            }// ScrollView
            .foregroundStyle(Color("Sec"))
            .font(.system(18))
            .toolbarBackground(Color("Prim"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            
        }//ZStack
        
    } // Body
} // StressView

struct MonthView: View {
    
    //@ObservedObject var viewModel: JournalViewModel
    // TODO: didn't know how to initalize this, so commented out for now.
    
    var metric: String
    
    @Query var allLogs: [metricsLog]
    
    
    @Query var thisMonthLogs: [metricsLog]
    @Query var lastMonthLogs: [metricsLog]
    var numOfDaysInMonth: Int
    
    
    init(startsOn startDate: Date, endsOn endDate: Date, metric: String) {
        let monthBefore = Calendar.current.date(byAdding: .month, value: -1, to: startDate)!
        
        let thisMonthPredicate = #Predicate<metricsLog> {
            startDate < $0.logDate &&
            $0.logDate <= endDate
        }
        
        let lastMonthPredicate = #Predicate<metricsLog> {
            monthBefore < $0.logDate &&
            $0.logDate <= startDate
            
        }
        
        _thisMonthLogs = Query(filter: thisMonthPredicate, sort: \.logDate)
        _lastMonthLogs = Query(filter: lastMonthPredicate, sort: \.logDate)
        numOfDaysInMonth = Calendar.current.numOfDaysInBetween(from: startDate, to: endDate)
        self.metric = metric
        
    }
    
    var body: some View {
        
        ZStack {
            
            Color("Prim")
                .ignoresSafeArea()// Background
            
            ScrollView {
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]) {
                    
                    if thisMonthLogs.count > 0 { // if data exists for this week
                        
                        Chart {
                            
                            ForEach(thisMonthLogs) { log in
                                LineMark(
                                    x: .value("Date", log.logDate),
                                    y: .value("Stress", log[metric])
                                )
                                .interpolationMethod(.linear)
                                .symbol(.square)
                                .foregroundStyle(Color("Sec"))
                                .offset(x:10)
                                
                            } // ForEach
                            
                            
                        } // Chart
                        .chartYAxis {
                            
                            AxisMarks(
                                values: [0, 5, 10]
                            ) {
                                AxisValueLabel()
                                    .foregroundStyle(Color("Sec"))
                                    .font(.system(10))
                            }
                            
                            AxisMarks(
                                values: [1, 2, 3, 4, 6, 7, 8, 9]
                            ) {
                                AxisGridLine()
                                    .foregroundStyle(Color("Sec"))
                            }
                            
                        }
                        .chartXVisibleDomain(length: 86400*numOfDaysInMonth) // https://stackoverflow.com/questions/77236097/swift-charts-chartxvisibledomain-hangs-or-crashes (measured in seconds)
                        .chartXAxis { AxisMarks(
                            preset: .aligned, position: .bottom,
                            values: .stride(by:.day, count:3), content:
                                {
                                    AxisValueLabel(format: .dateTime.day().month())
                                        .foregroundStyle(Color("Sec"))
                                    
                                    AxisGridLine()
                                        .foregroundStyle(Color("Sec"))
                                })
                        }
                        .padding(30)
                        .background(Color("Tint"))
                        .clipShape(.rect(cornerRadius: 20))
                        .frame(width:350, height:350)
                        .chartXScale(range: .plotDimension(padding: 10))
                        .chartYScale(domain: 0 ... 10, range: .plotDimension(padding: 10))
                        
                    } else { // if not
                        
                        Text("No Data")
                    }
                    
                    LazyVGrid(columns:  [GridItem(alignment: .topLeading), GridItem(alignment: .topLeading)]) {
                        
                        metricsAnalysisView(metric: metric, data: thisMonthLogs, beforeData: lastMonthLogs, duration: "month")
                        
                    }// LazyVGrid
                    .padding(10)
                    .background(Color("Tint"))
                    .clipShape(.rect(cornerRadius: 15))
                    .frame(width:350)
                    
                    metricWeekdayBarChart(data: allLogs, metric: metric)
                    
                }
                
                
            }// ScrollView
            .foregroundStyle(Color("Sec"))
            .font(.system(18))
            .toolbarBackground(Color("Prim"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            
        }//ZStack
        
    } // Body
} // StressView


struct metricsAnalysisView : View {
    let metric: String
    let data:[metricsLog]
    let beforeData:[metricsLog]
    var dataSortedFromLargest: [metricsLog] {
        return data.sorted { $0[metric] > $1[metric]}
    }
    
    init(metric: String, data: [metricsLog], beforeData: [metricsLog], duration: String) {
        self.metric = metric
        self.data = data
        self.beforeData = beforeData
        self.duration = duration
    }
    
    
    let periodInPast = [ "week": "last week", "month": "last month"]
    let duration: String // I am not sure if this is correct.
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text("Average:")
                .foregroundStyle(Color("Sec"))
                .font(.system(18))
            
            if data.count > 0 { // If data available for selected day
                
                let avgSleepString = String(format: "%.2f", metricsLog.getAvg(metricsLogs: data, metric: metric)) // round to 2dp
                
                Text("\(avgSleepString)")
                    .foregroundStyle(Color("Sec"))
                    .font(.systemSemiBold(20))
            } else {
                Text("No Data")
                    .foregroundStyle(Color("Sec"))
                    .font(.systemSemiBold(20))
                
            }
            
            
        }
        .foregroundStyle(Color("Sec"))
        .font(.systemSemiBold(20))
        .padding(10)
        
        VStack (alignment: .leading) {
            
            Text("Trend:")
                .foregroundStyle(Color("Sec"))
                .font(.system(18))
            
            if data.count > 0
                && beforeData.count > 0 {  // If data available for both selected day and day before.
                
                Text("\(metricsLog.calculatePercentage(previous: metricsLog.getAvg(metricsLogs: data, metric: "Sleep"), current: metricsLog.getAvg(metricsLogs: beforeData, metric: metric))) from \(periodInPast[duration] ?? "last week")")
                    .foregroundStyle(Color("Sec"))
                
            } else {
                Text("No Data")
                    .foregroundStyle(Color("Sec"))
            }
            
        }
        .foregroundStyle(Color("Sec"))
        .font(.systemSemiBold(20))
        .padding(10)
        
        VStack(alignment: .leading) {
            
            Text("Maximum:")
                .font(.system(18))
            
            if dataSortedFromLargest.count > 0 {
                
                Text("\(String(format: "%.2f", dataSortedFromLargest[0][metric])) on")
                Text(dataSortedFromLargest[0].logDate, format: .dateTime.day().month().weekday()) // show date and weekday
                
            } else {
                Text("No Data")
            }
        }
        .foregroundStyle(Color("Sec"))
        .font(.systemSemiBold(20))
        .padding(10)
        
        
        VStack(alignment: .leading) {
            
            Text("Minimum:")
                .font(.system(18))
            
            if dataSortedFromLargest.count > 0 {
                
                Text("\(String(format: "%.2f", dataSortedFromLargest[dataSortedFromLargest.count - 1][metric])) on")
                Text(dataSortedFromLargest[dataSortedFromLargest.count - 1].logDate, format: .dateTime.day().month().weekday()) // show date and weekday
                
            } else {
                Text("No Data")
            }
        }
        .foregroundStyle(Color("Sec"))
        .font(.systemSemiBold(20))
        .padding(10)
        
        
        
    }
}

struct metricWeekdayBarChart: View {
    var data:[metricsLog]
    var metric: String
    
    var body: some View {
        
        let weekdayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let weekdayAvgs = metricsLog.calcWeekdayAvgs(logs: data, metric: metric)
        
        var weekdayData:[(String, Double)] { // Create an array
            Array(zip(weekdayNames, weekdayAvgs))
        }
        
        Text("Average \(metric) by day of the week")
        
        Chart (weekdayData, id:\.0) { tuple in
            BarMark(
                x: .value("Weekday", tuple.0),
                y: .value("Stress", tuple.1)
            )
            .foregroundStyle(Color("Sec"))
            
        } // Chart
        .chartXAxis {
            AxisMarks(values: .automatic) { // https://zenn.dev/matsuei/articles/812d0476aa573f
                
                AxisValueLabel()
                    .foregroundStyle(Color("Sec"))
                    .font(.system(10))
            }
        }
        .chartYAxis {
            
            AxisMarks(
                values: [0, 5, 10]
            ) {
                AxisValueLabel()
                    .foregroundStyle(Color("Sec"))
                    .font(.system(10))
            }
            
            AxisMarks(
                values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            ) {
                AxisGridLine()
                    .foregroundStyle(Color("Sec"))
            }
            
        }
        .padding(30)
        .background(Color("Tint"))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width:350, height:350)
        .foregroundStyle(Color("Sec"))
        .chartXScale(range: .plotDimension(padding: 10))
        .chartYScale(domain: 0 ... 10, range: .plotDimension(padding: 10))
        
    }
}





struct TimeSpanPicker: View {
    @Binding var page: String
    
    var body: some View {
        HStack {
            
            Text("Week")
                .padding()
                .background(page == "week" ? Color("Tint") : Color("Prim"))
                .foregroundColor(page == "week" ? Color("Sec") : Color("Sec"))
                .clipShape(.rect(cornerRadius:5)) // ios 13.0+
                .onTapGesture {
                    page = "week"
                }
            
            Text("Month")
                .padding()
                .background(page == "month" ? Color("Tint") : Color("Prim"))
                .foregroundColor(page == "month" ? Color("Sec") : Color("Sec"))
                .clipShape(.rect(cornerRadius:5))
                .onTapGesture {
                    page = "month"
                }
        }
        .font(.system(17))
    }
}
