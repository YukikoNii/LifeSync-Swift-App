

import SwiftUI
import Charts
import SwiftData
import Foundation


struct CorrelationAnalysisView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @Query var daySummaries: [summaryLog]
    
    var body: some View {
        
        
        ZStack {
            Color("Sec")
                .ignoresSafeArea()
            
            ScrollView {
                
                Text("Stress vs Sleep")
                
                ChartView(daySummaries: daySummaries, metric: "sleep")
                
                Text("Stress vs Activity")
                
                ChartView(daySummaries: daySummaries, metric: "activity")
                
                Text("Stress vs Diet")
                
                ChartView(daySummaries: daySummaries, metric: "diet")
                
                Text("Stress vs Work")
                
                ChartView(daySummaries: daySummaries, metric: "work")
                
            } //scrollview
            
            
            // TODO: if i turn off blur effect, it stops scrolling.
            
            
            
        } // ZStack
        .font(.system(18))
        .foregroundStyle(Color("Prim"))
        
        
    }
    
}



struct ChartView: View {
    
    let daySummaries: [summaryLog]
    
    let metric: String
    
    var body: some View {
        Chart {
            ForEach(daySummaries, id: \.self) { data in
                PointMark(
                    x: .value("Date", data.avgStress),
                    y: .value("Stress", data[metric])
                )
                .symbol(.square)
                .foregroundStyle(Color("Prim"))
            

                
            } // ForEach
        } // Chart
        .chartXAxisLabel("Average Stress")
        .chartYAxisLabel("\(metric)")
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
            
            AxisMarks(preset: .aligned, position: .leading,
                      values: [ 1, 2, 3, 4, 5, 6, 7, 8, 9], content: {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Prim")) // change the color for  readability
                
                
            })
            
            AxisMarks(
                preset: .aligned, position: .leading,
                values: [0, 10], content:
                    {
                        
                        AxisGridLine()
                            .foregroundStyle(Color("Prim"))
                        
                        AxisValueLabel()
                            .font(.system(10))
                            .foregroundStyle(Color("Prim")) // change the color for  readability
                    })
            
        }
        .font(.system(10))
        .foregroundStyle(Color("Prim"))
        .padding(30)
        .background(Color("Tint"))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width:350, height:350)
        
    }
}


/*
 {
 AxisValueLabel()
 .font(.system(10))
 .foregroundStyle(Color("Prim")) // change the color for  readability
 }
 */
