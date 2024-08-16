
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
        let weekStartDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(-86400*6))
        
            
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
                    DatePicker("", selection: $selectedDay, displayedComponents: [.date])
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding()
                    
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

    
    @Query var dailyStressLog: [stressLog]
    @Query var dayBeforeStressLog: [stressLog]
    

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
            
        _dailyStressLog = Query(filter: predicateDailyLog, sort: \.logDate)
        _dayBeforeStressLog = Query(filter: predicateDayBefore, sort: \.logDate)
    }
    
    
    var body: some View {
                
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            ScrollView {
                // CHART FOR TODAY
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
                .frame(width:350, height:350)
                
                
                // Data Analysis

                
                // TODO: maybe make a function to reduce repeats
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    
                    AnalysisView(data: dailyStressLog, beforeData: dayBeforeStressLog, duration: "day")
        
                    
            
                }// LazyVGrid
                .padding(10)
                .background(Color("Var"))
                .clipShape(.rect(cornerRadius: 15))
                .frame(width:350) // TODO: I am not sure if this is a right idea

                // CORREELATION TEST
                
                /*
                 
                 Chart {
                 ForEach(test) { log in
                 TODO: changing.
                 PointMark(
                 x: .value("Date", log.stress),
                 y: .value("Stress", log.sleep)
                 )
                 
                 .symbol(.square)
                 .foregroundStyle(Color("Sec"))
                 
                 } // ForEach
                 } // Chart
                 .chartXAxis {
                 
                 AxisMarks(
                 values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                 )
                 {
                 
                 AxisValueLabel()
                 .font(.system(10))
                 .foregroundStyle(Color("Sec")) // change the color for  readability
                 }
                 
                 AxisMarks(
                 values: [0, 10]
                 )
                 {
                 
                 AxisGridLine()
                 .foregroundStyle(Color("Sec"))
                 
                 AxisValueLabel()
                 .font(.system(10))
                 .foregroundStyle(Color("Sec")) // change the color for  readability
                 }
                 
                 
                 }
                 .chartYAxis {
                 
                 AxisMarks(
                 values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                 )
                 {
                 
                 AxisValueLabel()
                 .font(.system(10))
                 .foregroundStyle(Color("Sec")) // change the color for  readability
                 }
                 
                 AxisMarks(
                 values: [0, 10]
                 )
                 {
                 
                 AxisGridLine()
                 .foregroundStyle(Color("Sec"))
                 
                 AxisValueLabel()
                 .font(.system(10))
                 .foregroundStyle(Color("Sec")) // change the color for  readability
                 }
                 
                 
                 }
                 .frame(width:350, height:300)
                 */
                
            
            }// ScrollView
            .foregroundStyle(Color("Sec"))
            .font(.system(18))
            
        }//ZStack
        
    } // Body
} // StressView

struct WeekStressView: View {
    
    @Query var weeklyStressLog: [stressLog]
    @Query var weekBeforeStressLog: [stressLog]
    
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
        
        _weeklyStressLog = Query(filter: predicateDailyLog, sort: \.logDate)
        _weekBeforeStressLog = Query(filter: predicateDayBefore, sort: \.logDate)
    }
    
    var body: some View {
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            ScrollView {
                
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
                
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    
                    AnalysisView(data: weeklyStressLog, beforeData: weekBeforeStressLog, duration: "week")
                    
                }// LazyVGrid
                .padding(10)
                .background(Color("Var"))
                .clipShape(.rect(cornerRadius: 15))
                .frame(width:350)
                                
            }
        }
        
    }
}
    
    
    
    struct AnalysisView : View {
        let data:[stressLog]
        let beforeData:[stressLog]
        let periodInPast = ["day": "yesterday", "week": "last week", "month": "last month"]
        let duration: String // I am not sure if this is correct.
        
        var body: some View {
            
            if !stressLog.getStressAvg(dayStressLogs: data).isNaN { // If data available for selected day
                
                let avgStressString = String(format: "%.2f", stressLog.getStressAvg(dayStressLogs: data)) // round to 2dp
                
                VStack (alignment: .leading) {
                    
                    Text("Average:")
                        .foregroundStyle(Color("Prim"))
                        .font(.system(18))
                    
                    Text("\(avgStressString)")
                        .foregroundStyle(Color("Prim"))
                        .font(.systemSemiBold(20))
                }
                
            }
            
            if !stressLog.getStressAvg(dayStressLogs: data).isNaN
                && !stressLog.getStressAvg(dayStressLogs: beforeData).isNaN {  // If data available for both  selected day and day before.
                
                VStack (alignment: .leading) {
                    Text("Stress level:") // TODO: prevent NaN
                        .foregroundStyle(Color("Prim"))
                        .font(.system(18))
                    
                    if let duration = periodInPast[duration] {
                        
                        Text("\(stressLog.calculatePercentage(day1: stressLog.getStressAvg(dayStressLogs: data), day2: stressLog.getStressAvg(dayStressLogs: beforeData))) % compared to \(duration)")
                            .foregroundStyle(Color("Prim"))
                            .font(.systemSemiBold(20))
                        
                    }
                }
                
            }
            // TODO: when your stress level is highest
            
            
            
        }
    }
    
    
    

