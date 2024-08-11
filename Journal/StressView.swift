
import SwiftUI
import Charts
import SwiftData
import Foundation

struct StressView: View {
    
    // I AM STUCK.
    //@ObservedObject  var viewModel: JournalViewModel

    @Environment(\.modelContext) private var context
    @State static var selectedDay = Date()
    @State static var dayBefore = selectedDay.addingTimeInterval(-86400)
    
    @Query(filter: stressLog.dayLog(date: selectedDay), sort: \.logDate) var dayLog: [stressLog] // trying to do dynamic filter; not really working.
    @Query(filter: stressLog.dayLog(date: dayBefore), sort: \.logDate) var dayBeforeLog: [stressLog]
    @Query(sort: \stressLog.logDate) var logs: [stressLog]
    
    var endDate = Calendar.current.startOfDay(for: selectedDay.addingTimeInterval(86400))
    var startDate = Calendar.current.startOfDay(for: selectedDay)
    
    
    
    @Query var pleaseWork: [stressLog]

    init(startDate: Date, endDate: Date) {
        let predicate = #Predicate<stressLog> {
            startDate < $0.logDate &&
            $0.logDate < endDate
        }
        _pleaseWork = Query(filter: predicate, sort: \.logDate)
    }
    
    
    var body: some View {
        
        //var dailyAverage = log.getStressAvg(dayStressLogs: logs)
        
        ScrollView {
            // CHART FOR TODAY
            Text("Daily")
            
            DatePicker("", selection: StressView.$selectedDay, displayedComponents: [.date])
                .labelsHidden()
                .colorScheme(.dark)
                .padding()
            
            
            

            
            Text(stressLog.getStressAvg(dayStressLogs: logs).isNaN ? "": "Today's average: \(stressLog.getStressAvg(dayStressLogs: logs))")
            /*Text(stressLog.getStressAvg(dayStressLogs: logs).isNaN ? "": "Your stress level is \(stressLog.calculatePercentage(day1: stressLog.getStressAvg(dayStressLogs: dayLog), day2: stressLog.getStressAvg(dayStressLogs: dayBeforeLog)))% compared to yesterday.") */
            
            // TODO: when your stress level is highest
            // TODO: when
            
            
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
        
    } // Body
} // StressView

struct TestView:View {
    var body: some View {
        
        Chart {
        
            ForEach(pleaseWork) { log in
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
    }
    
}






