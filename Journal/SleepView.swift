
import SwiftUI
import Charts
import SwiftData
import Foundation

struct SleepDatePickerView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @State var selectedDay = Date()
    @State var index = 1
    @State var changeDate:Double = 0
    
    var body: some View {
        
        let endDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400*1))
        let startDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(-86400*6))
        
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
                    SleepView(startDate: startDate, endDate: endDate)
                        .tag(1)
                }
            } // VStack
        } //ZStack
    }
}

struct SleepView: View {
    
    //@ObservedObject var viewModel: JournalViewModel
    // TODO: didn't know how to initalize this, so commented out for now.
    
    @Query var sleepLogsForThisWeek: [dailyFactorsLog]
    @Query var sleepLogsForLastWeek: [dailyFactorsLog]
    
    @State var index = 0


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
            
        _sleepLogsForThisWeek = Query(filter: thisWeekPredicate, sort: \.logDate)
        _sleepLogsForLastWeek = Query(filter: lastWeekPredicate, sort: \.logDate)
    }
    
    
    var body: some View {
        
        //var dailyAverage = log.getStressAvg(dayStressLogs: logs)
        
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()// Background
            
            ScrollView {
                // CHART FOR TODAY
                Chart {
                    
                    ForEach(sleepLogsForThisWeek) { log in
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
                .frame(width:350, height:400)
                
                
                
            }// ScrollView
            .foregroundStyle(Color("Prim"))
            .font(.system(18))
            
        }//ZStack
        
    } // Body
} // StressView








