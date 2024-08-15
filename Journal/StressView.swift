
import SwiftUI
import Charts
import SwiftData
import Foundation

struct StressDatePickerView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @State var selectedDay = Date()
    @State var index = 1
    @State var changeDate:Double = 0
    
    var body: some View {
        
        let endDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400*(changeDate+1)))
        let startDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400*changeDate))
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            VStack {
                
                Text("Daily")
                    .font(.system(18))
                    .foregroundStyle(Color("Sec"))
                
                DatePicker("", selection: $selectedDay, displayedComponents: [.date])
                    .labelsHidden()
                    .colorScheme(.dark)
                    .padding()
                
                TabView(selection: $index) { // Using TabView as a work around for Dynamic Query
                    StressView(startDate: startDate, endDate: endDate)
                        .tag(1)
                }
            } // VStack
        } //ZStack
    }
}

struct StressView: View {
    
    //@ObservedObject var viewModel: JournalViewModel
    // TODO: didn't know how to initalize this, so commented out for now.

    @Query(sort: \stressLog.logDate) var logs: [stressLog]
    
    @Query var dailyStressLog: [stressLog]
    @Query var dayBeforeStressLog: [stressLog]
    
    @State var index = 0


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
        
        //var dailyAverage = log.getStressAvg(dayStressLogs: logs)
        
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
                        .foregroundStyle(Color("Sec"))
                        .offset(x:10)
                        
                    } // ForEach
                    
                    
                } // Chart
                .chartYAxis {
                    
                    AxisMarks(
                        values: [0, 5, 10]
                    ) {
                        AxisValueLabel()
                            .foregroundStyle(Color("Sec")) // change the color for  readability
                            .font(.system(10))
                    }
                    
                    AxisMarks(
                        values: [1, 2, 3, 4, 6, 7, 8, 9]
                    ) {
                        AxisGridLine()
                            .foregroundStyle(Color("Sec"))
                    }
                    
                }
                .chartScrollableAxes(.horizontal) // https://swiftwithmajid.com/2023/07/25/mastering-charts-in-swiftui-scrolling/
                .chartXVisibleDomain(length: 86400) // https://stackoverflow.com/questions/77236097/swift-charts-chartxvisibledomain-hangs-or-crashes (measured in seconds)
                .chartXAxis {
                    AxisMarks(values: .stride(by:.hour, count:3)) { // https://zenn.dev/matsuei/articles/812d0476aa573f
                        
                        AxisValueLabel(format:.dateTime.hour())
                            .foregroundStyle(Color("Sec"))
                            .font(.system(10))
                        
                        AxisGridLine()
                            .foregroundStyle(Color("Sec"))
                    }
                    AxisMarks(values:.stride(by:.day, count:1)) {
                        
                        AxisValueLabel()
                            .foregroundStyle(Color("Sec"))
                            .font(.system(10))
                            .offset(x:-10, y:15)
                    }
                }
                .frame(width:350, height:400)
                
                
                // Data Analysis
                
                if !stressLog.getStressAvg(dayStressLogs: dailyStressLog).isNaN { // If data available for selected day
                    
                    let avgStressString = String(format: "%.2f", stressLog.getStressAvg(dayStressLogs: dailyStressLog)) // round to 2dp
                    
                    Text("Average: \(avgStressString)")
                }
                
                if !stressLog.getStressAvg(dayStressLogs: dailyStressLog).isNaN
                    && !stressLog.getStressAvg(dayStressLogs: dayBeforeStressLog).isNaN {  // If data available for both  selected day and day before.
                    
                    
                    Text("Your stress level is \(stressLog.calculatePercentage(day1: stressLog.getStressAvg(dayStressLogs: dailyStressLog), day2: stressLog.getStressAvg(dayStressLogs: dayBeforeStressLog)))% compared to the day before.") // TODO: prevent NaN
                }
                
                // TODO: when your stress level is highest
                
                
                // CHART FOR WEEK
                Text("Weekly")
                
                Chart {
                    ForEach(logs) { log in
                        
                        LineMark(
                            x: .value("Date", log.logDate),
                            y: .value("Stress", log.stressLevel)
                        )
                        .interpolationMethod(.catmullRom)
                        .symbol(.square)
                        .foregroundStyle(Color("Sec"))
                        
                        
                    } // ForEach
                } // Chart
                .chartYAxis {
                    AxisMarks(
                        values: [0, 5, 10]
                    ) {
                        AxisValueLabel()
                            .foregroundStyle(Color("Sec")) // change the color for  readability
                    }
                    
                    AxisMarks(
                        values: [1, 2, 3, 4, 6, 7, 8, 9]
                    ) {
                        AxisGridLine()
                            .foregroundStyle(Color("Sec"))
                    }
                }
                .chartScrollableAxes(.horizontal) // https://swiftwithmajid.com/2023/07/25/mastering-charts-in-swiftui-scrolling/
                .chartXVisibleDomain(length: 86400*7) // https://stackoverflow.com/questions/77236097/swift-charts-chartxvisibledomain-hangs-or-crashes (measured in seconds)
                .chartXAxis {AxisMarks(values: .automatic) {
                    AxisValueLabel()
                        .foregroundStyle(Color("Sec"))
                    
                    AxisGridLine()
                        .foregroundStyle(Color("Sec"))
                }
                }
                .frame(width:350, height:300)
                
                
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






