
import SwiftUI
import Charts
import SwiftData
import Foundation

struct StressView: View {
    
    @Environment(\.modelContext) private var context
    @Query var logs: [log]
    @State static var selectedDay = Date()
    @State static var dayBefore = selectedDay.addingTimeInterval(-86400)
    
    @Query(filter: log.dayLog(date: selectedDay), sort: \.logDate) var dayLog: [log]
    
    private var dynamicDayLogs: [log] {
        return dayLog.filter(log.dayLog(date: selectedDay))
    }
    
    @Query(filter: log.dayLog(date: dayBefore), sort: \.logDate) var dayBeforeLog: [log]
    
    var body: some View {
        
        ScrollView {
            // CHART FOR TODAY
            
            DatePicker("", selection: StressView.$selectedDay, displayedComponents: [.date])
                .labelsHidden()
                .colorScheme(.dark)
                .padding()
            
            Chart {
                ForEach(dayLog) { log in
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
            .chartXAxis {AxisMarks(values: .automatic) {
                AxisValueLabel()
                    .foregroundStyle(Color("Sec"))
                
                AxisGridLine()
                    .foregroundStyle(Color("Sec"))
            }
            }
            .frame(width:350, height:300)
            
            Text(log.getStressAvg(dayStressLogs: logs).isNaN ? "No Data": "Today's average: \(log.getStressAvg(dayStressLogs: logs))")
            Text(log.getStressAvg(dayStressLogs: logs).isNaN ? "No Data": "Your stress level was \(log.calculatePercentage(day1: log.getStressAvg(dayStressLogs: dayLog), day2: log.getStressAvg(dayStressLogs: dayBeforeLog)))% compared to last week.")
            
            // CHART FOR WEEK
            Text("This Week")
            
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
            
        }// ScrollView
        .foregroundStyle(Color("Sec"))
        .font(.system(18))
        
    }
}






