
import SwiftUI
import Charts
import SwiftData
import Foundation

struct StressDatePickerView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @State var selectedDay = Date()
    @State var index = 0
    @State var changeDate:Double = 0
    
    var body: some View {
        
        let dayEndDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400*(changeDate+1)))
        let dayStartDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400*changeDate))
        
        let weekEndDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400*(changeDate+1)))
        let weekStartDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(-86400*7))
        
        
        ZStack {
            Color("Sec")
                .ignoresSafeArea()// Background
            
            
            VStack {
                HStack {
                    Text("Day")
                        .padding()
                        .background(index == 0 ? Color("Var") : Color("Sec"))
                        .foregroundColor(index == 0 ? Color("Prim") : Color("Prim"))
                        .font(.system(17))
                        .clipShape(.rect(cornerRadius:5))
                        .onTapGesture {
                            index = 0
                        }
                    
                    Text("Week")
                        .padding()
                        .background(index == 1 ? Color("Var") : Color("Sec"))
                        .foregroundColor(index == 1 ? Color("Prim") : Color("Prim"))
                        .font(.system(17))
                        .clipShape(.rect(cornerRadius:5))
                        .onTapGesture {
                            index = 1
                        }
                    
                    Text("Month")
                        .padding()
                        .background(index == 2 ? Color("Var") : Color("Sec"))
                        .foregroundColor(index == 2 ? Color("Prim") : Color("Prim"))
                        .font(.system(17))
                        .clipShape(.rect(cornerRadius:5))
                        .onTapGesture {
                            index = 2
                        }
                }
                
                HStack {
                    if index == 1 {
                        Text(weekStartDate, format: .dateTime.day().month().year())
                            .foregroundStyle(Color(.white))
                        Text(" to")
                            .foregroundStyle(Color(.white))
                        
                    }
                    
                    DatePicker("", selection: $selectedDay, displayedComponents: [.date])
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding()
                    
                }
                
                TabView(selection: $index) { // Using TabView as a work around for Dynamic Query
                    DayStressView(startDate: dayStartDate, endDate: dayEndDate)
                        .tag(0)
                    
                    WeekStressView(startDate: weekStartDate, endDate: weekEndDate)
                        .tag(1)
                }
            } // VStack
        } //ZStack
    }
}

struct DayStressView: View {
    
    //@ObservedObject var viewModel: JournalViewModel
    // TODO: didn't know how to initalize this, so commented out for now.
    
    @Query var logs: [stressLog]
    
    @Query var dailyStressLog: [stressLog]
    @Query var dayBeforeStressLog: [stressLog]
    @Query var maxStress: [stressLog]
    
    
    init(startDate: Date, endDate: Date) {
        
        let dayBefore = startDate.addingTimeInterval(-86400)
        let predicateDailyLog = #Predicate<stressLog> {
            startDate < $0.logDate &&
            $0.logDate < endDate
        }
        
        let predicateDayBefore = #Predicate<stressLog> {
            dayBefore < $0.logDate &&
            $0.logDate < startDate
            
        }
        
        var descriptor: FetchDescriptor<stressLog> {
            var descriptor = FetchDescriptor<stressLog>(predicate: predicateDailyLog, sortBy: [SortDescriptor(\.stressLevel, order: .reverse)])
            descriptor.fetchLimit = 1
            return descriptor
        }
        
        _dailyStressLog = Query(filter: predicateDailyLog, sort: \.logDate)
        _dayBeforeStressLog = Query(filter: predicateDayBefore, sort: \.logDate)
        
        _maxStress = Query(descriptor)
    }
    
    
    var body: some View {
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            ScrollView {
                // CHART FOR TODAY
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]) {
                    if dailyStressLog.count != 0 {
                        
                        Chart {
                            
                            ForEach(dailyStressLog) { log in
                                LineMark(
                                    x: .value("Date", log.logDate),
                                    y: .value("Stress", log.stressLevel)
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
                                values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            ) {
                                AxisGridLine()
                                    .foregroundStyle(Color("Prim"))
                            }
                            
                        }
                        .chartScrollableAxes(.horizontal) // https://swiftwithmajid.com/2023/07/25/mastering-charts-in-swiftui-scrolling/
                        .chartXVisibleDomain(length: 86400) // https://stackoverflow.com/questions/77236097/swift-charts-chartxvisibledomain-hangs-or-crashes (measured in seconds)
                        .chartXAxis {
                            AxisMarks(values: .stride(by:.hour, count:3)) { // https://zenn.dev/matsuei/articles/812d0476aa573f
                                
                                AxisValueLabel(format:.dateTime.hour())
                                    .foregroundStyle(Color("Prim"))
                                    .font(.system(10))
                                
                                AxisGridLine()
                                    .foregroundStyle(Color("Prim"))
                            }
                            AxisMarks(values:.stride(by:.day, count:1)) {
                                
                                AxisValueLabel()
                                    .foregroundStyle(Color("Prim"))
                                    .font(.system(10))
                                    .offset(x:-10, y:15)
                            }
                        }
                        .padding(30)
                        .background(Color("Var"))
                        .clipShape(.rect(cornerRadius: 20))
                        .frame(width: 350, height:350)
                        
                    } else {
                        
                        Text("No Data")
                            .frame(width: 300)
                    }
                    
                    
                    // Data Analysis
                    
                    
                    LazyVGrid(columns: [GridItem(alignment: .topLeading), GridItem(alignment: .topLeading)]) {
                        
                        AnalysisView(data: dailyStressLog, beforeData: dayBeforeStressLog, maxStress: maxStress, duration: "day")
                        
                        
                    }// LazyVGrid
                    .padding(10)
                    .background(Color("Var"))
                    .clipShape(.rect(cornerRadius: 15))
                    .frame(width:350) // TODO: I am not sure if this is a right idea
                    
                    TimeOfDayBarChart(data: logs)
                    
                }
                
                
            }
            .foregroundStyle(Color("Prim"))
            .font(.system(18))
            
            
            
            
        }//ZStack
        
        
    } // Body
} // StressView

struct WeekStressView: View {
    
    @Query var weeklyStressLog: [stressLog]
    @Query var weekBeforeStressLog: [stressLog]
    
    @Query var maxStress: [stressLog]
    
    init(startDate: Date, endDate: Date) {
        
        let dayBefore = startDate.addingTimeInterval(-86400*7)
        let predicateDailyLog = #Predicate<stressLog> {
            startDate < $0.logDate &&
            $0.logDate < endDate
        }
        
        let predicateDayBefore = #Predicate<stressLog> {
            dayBefore < $0.logDate &&
            $0.logDate < startDate
            
        }
        
        var descriptor: FetchDescriptor<stressLog> {
            var descriptor = FetchDescriptor<stressLog>(predicate: predicateDailyLog, sortBy: [SortDescriptor(\.stressLevel, order: .reverse)])
            descriptor.fetchLimit = 1
            return descriptor
        }
        
        _weeklyStressLog = Query(filter: predicateDailyLog, sort: \.logDate)
        _weekBeforeStressLog = Query(filter: predicateDayBefore, sort: \.logDate)
        _maxStress = Query(descriptor)
    }
    
    var body: some View {
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            ScrollView {
                
                if weeklyStressLog.count != 0 {
                    
                    Chart {
                        ForEach(weeklyStressLog) { log in
                            
                            LineMark(
                                x: .value("Date", log.logDate),
                                y: .value("Stress", log.stressLevel)
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
                        }
                        
                        AxisMarks(
                            values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
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
                    .background(Color("Var"))
                    .clipShape(.rect(cornerRadius: 20))
                    .frame(width:350, height:350)
                    
                } else {
                    
                    Text("No Data")
                    
                }
                
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    
                    AnalysisView(data: weeklyStressLog, beforeData: weekBeforeStressLog, maxStress: maxStress, duration: "week")
                    
                }// LazyVGrid
                .padding(10)
                .background(Color("Var"))
                .clipShape(.rect(cornerRadius: 15))
                .frame(width:350)
                
                WeekdayBarChart(data: weeklyStressLog)
                
                
                
            } // ScrollView
            .font(.system(18))
            .foregroundStyle(Color("Prim"))
            
        }
        
    }
}



struct AnalysisView : View {
    let data:[stressLog]
    let beforeData:[stressLog]
    let maxStress: [stressLog]
    let periodInPast = ["day": "yesterday", "week": "last week", "month": "last month"]
    let duration: String // I am not sure if this is correct.
    
    
    
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text("Average: ")
                .font(.system(18))
            
            if !stressLog.getStressAvg(dayStressLogs: data).isNaN { // If data available for selected day
                
                let avgStressString = String(format: "%.2f", stressLog.getStressAvg(dayStressLogs: data)) // round to 2dp
                
                Text("\(avgStressString)")
                    .foregroundStyle(Color("Prim"))
            } else {
                Text("No Data")
                
            }
            
            
        }
        .padding(10)
        .foregroundStyle(Color("Prim"))
        .font(.systemSemiBold(20))
        
        
        VStack (alignment: .leading) {
            
            Text("Trend:")
                .font(.system(18))
            
            if !stressLog.getStressAvg(dayStressLogs: data).isNaN
                && !stressLog.getStressAvg(dayStressLogs: beforeData).isNaN {  // If data available for both  selected day and day before.
                
                if let duration = periodInPast[duration] {
                    
                    Text("\(stressLog.calculatePercentage(day1: stressLog.getStressAvg(dayStressLogs: data), day2: stressLog.getStressAvg(dayStressLogs: beforeData))) % compared to \(duration)")
                    
                }
            } else {
                Text("No Data")
            }
            
        }
        .padding(10)
        .foregroundStyle(Color("Prim"))
        .font(.systemSemiBold(20))
        
        
        
        VStack(alignment: .leading) {
            
            Text("Maximum:")
                .font(.system(18))
            
            if maxStress.count != 0 {
                
                let maxStressString = String(format: "%.2f", maxStress[0].stressLevel)
                
                if duration == "day" {   // If day selected
                    
                    HStack {
                        Text("\(maxStressString) at")
                        Text(maxStress[0].logDate, format: .dateTime.hour().minute()) // show the time
                    }
                } else if duration == "week" { // if week selected
                    HStack {
                        Text("\(maxStressString) on")
                        Text(maxStress[0].logDate, format: .dateTime.day().month()) // show date
                    }
                }
            }
            else {
                Text("No Data")
            }
            
        }
        .foregroundStyle(Color("Prim"))
        .font(.systemSemiBold(20))
        .padding(10)
        
        
        
    }
}


struct WeekdayBarChart: View {
    var data:[stressLog]
    
    var body: some View {
        
        
        var weekdayData:[(String, Double)] {
            Array(zip(weekdayNames, weekdayAvgs))
        }
        
        let weekdayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let weekdayAvgs = stressLog.calcWeekdayAvgs(dayStressLogs: data)
        
        
        Text("Average Stress Level by Day of the Week")
        
        Chart (weekdayData, id:\.0) { tuple in
            BarMark(
                x: .value("Weekday", tuple.0),
                y: .value("Stress", tuple.1)
            )
            .foregroundStyle(Color("Prim"))

        } // Chart
        .chartXAxis {
            AxisMarks(values: .automatic) { // https://zenn.dev/matsuei/articles/812d0476aa573f
                
                AxisValueLabel()
                    .foregroundStyle(Color("Prim"))
                    .font(.system(10))
            }
        }
        .chartYAxis {
            
            AxisMarks(
                values: [0, 5, 10]
            ) {
                AxisValueLabel()
                    .foregroundStyle(Color("Prim"))
                    .font(.system(10))
            }
            
            AxisMarks(
                values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            ) {
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
            }
            
        }
        .padding(30)
        .background(Color("Var"))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width:350, height:350)
        .foregroundStyle(Color("Prim"))
        
    }
}

struct TimeOfDayBarChart: View {
    var data:[stressLog]
    
    var body: some View {
        
        
        var timeOfDayData:[(String, Double)] {
            Array(zip(timeSpans, timeOfDayAvgs))
        }
        
        let timeSpans = ["0-3", "3-6", "6-9", "9-12", "12-15", "15-18", "18-21", "21-24"]
        let timeOfDayAvgs = stressLog.calcTimeOfDayAvgs(dayStressLogs: data)
        
        
        Text("Average Stress Level by Time of the Day")
        
        Chart (timeOfDayData, id:\.0) { tuple in
            BarMark(
                x: .value("Weekday", tuple.0),
                y: .value("Stress", tuple.1)
            )
            .foregroundStyle(Color("Prim"))

        } // Chart
        .chartXAxis {
            AxisMarks(values: .automatic) { // https://zenn.dev/matsuei/articles/812d0476aa573f
                
                AxisValueLabel()
                    .foregroundStyle(Color("Prim"))
                    .font(.system(10))
            }
        }
        .chartYAxis {
            
            AxisMarks(
                values: [0, 5, 10] // TODO:  When there is no data, the order is reversed. Fix this.
            ) {
                AxisValueLabel()
                    .foregroundStyle(Color("Prim"))
                    .font(.system(10))
            }
            
            AxisMarks(
                values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            ) {
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
            }
            
        }
        .padding(30)
        .background(Color("Var"))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width:350, height:350)
        .foregroundStyle(Color("Prim"))
        
    }
}






