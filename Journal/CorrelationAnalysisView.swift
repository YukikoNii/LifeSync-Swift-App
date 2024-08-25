

import SwiftUI
import Charts
import SwiftData
import Foundation


struct CorrelationAnalysisView: View {
    @ObservedObject var viewModel: JournalViewModel

    @Query(filter: daySummary.dayLog(date: Date.now)) var daySummaries: [daySummary]
    
    var body: some View {
        
            
            ZStack {
                Color("Sec")
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    CorrelationChartView(daySummaries: daySummaries)
                    
                } //scrollview


                // TODO: if i turn off blur effect, it stops scrolling.
                
                
                
            } // ZStack
            .font(.system(18))
            .foregroundStyle(Color("Prim"))
            
        
    }
   
}

struct CorrelationChartView: View {
    
    let daySummaries: [daySummary]
    
    var body: some View {
        
        Text("Stress vs Sleep")

        ChartView(daySummaries: daySummaries, selectedCategory: "sleep")
        .chartXAxis {
            
            AxisMarks(
                values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
            )
            {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            AxisMarks(
                values: [0, 10]
            )
            {
                
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            
        }
        .chartYAxis {
            
            AxisMarks(
                values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
            )
            {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            AxisMarks(
                values: [0, 10]
            )
            {
                
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            
        }
        .padding(30)
        .background(Color("Tint"))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width:350, height:350)
        
        Text("Stress vs Activity")
        
        ChartView(daySummaries: daySummaries, selectedCategory: "activity")
        .chartXAxis {
            
            AxisMarks(
                values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
            )
            {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            AxisMarks(
                values: [0, 10]
            )
            {
                
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            
        }
        .chartYAxis {
            
            AxisMarks(
                values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
            )
            {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            AxisMarks(
                values: [0, 10]
            )
            {
                
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            
        }
        .padding(30)
        .background(Color("Tint"))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width:350, height:350)
        
        Text("Stress vs Diet")

        
        ChartView(daySummaries: daySummaries, selectedCategory: "diet")
        .chartXAxis {
            
            AxisMarks(
                values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
            )
            {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            AxisMarks(
                values: [0, 10]
            )
            {
                
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            
        }
        .chartYAxis {
            
            AxisMarks(
                values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
            )
            {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            AxisMarks(
                values: [0, 10]
            )
            {
                
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            
        }
        .padding(30)
        .background(Color("Tint"))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width:350, height:350)
        
        Text("Stress vs Work")

        
        ChartView(daySummaries: daySummaries, selectedCategory: "work")
        .chartXAxis {
            
            AxisMarks(
                values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
            )
            {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            AxisMarks(
                values: [0, 10]
            )
            {
                
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            
        }
        .chartYAxis {
            
            AxisMarks(
                values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
            )
            {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            AxisMarks(
                values: [0, 10]
            )
            {
                
                AxisGridLine()
                    .foregroundStyle(Color("Prim"))
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
            }
            
            
        }
        .padding(30)
        .background(Color("Tint"))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width:350, height:350)
        

    }
}

struct ChartView: View {
    let daySummaries: [daySummary]
 
    let selectedCategory: String

    var body: some View {
        if selectedCategory == "activity" {
            Chart {
                ForEach(daySummaries) { log in
                    PointMark(
                        x: .value("Date", log.avgStress),
                        y: .value("Stress", log.activity)
                    )
                    
                    .symbol(.square)
                    .foregroundStyle(Color("Prim"))
                    
                } // ForEach
            }
        }
        
        if selectedCategory == "diet" {
            Chart {
                ForEach(daySummaries) { log in
                    PointMark(
                        x: .value("Date", log.avgStress),
                        y: .value("Stress", log.diet)
                    )
                    
                    .symbol(.square)
                    .foregroundStyle(Color("Prim"))
                    
                } // ForEach
            }
        }
        
        if selectedCategory == "work" {
            Chart {
                ForEach(daySummaries) { log in
                    PointMark(
                        x: .value("Date", log.avgStress),
                        y: .value("Stress", log.work)
                    )
                    
                    .symbol(.square)
                    .foregroundStyle(Color("Prim"))
                    
                } // ForEach
            }
        }
        
        if selectedCategory == "sleep" {
            Chart {
                ForEach(daySummaries) { log in
                    PointMark(
                        x: .value("Date", log.avgStress),
                        y: .value("Stress", log.sleep)
                    )
                    
                    .symbol(.square)
                    .foregroundStyle(Color("Prim"))
                    
                } // ForEach
            }
        }
        
        
    }
}

