

import SwiftUI
import Charts
import SwiftData


struct CorrelationAnalysisView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    @Query var daySummaries: [summaryLog]
    
    var body: some View {
        
        ZStack {
            Color("Prim")
                .ignoresSafeArea()
            
            ScrollView {
                
                ForEach(viewModel.metrics, id: \.self) { metric in
                    
                    Text("Stress vs \(metric)")
                    
                    ChartView(summaryLogs: daySummaries, metric: metric) // TODO: I am not sure if this is a good idea.
                }
                
            } //scrollview
            
        } // ZStack
        .font(.systemSemiBold(18))
        .foregroundStyle(Color("Sec"))
    }
}


struct ChartView: View {
    
    let summaryLogs: [summaryLog]
    let metric: String
    
    var bestFitLineCoordinates: [String:Double]  {
        calculateBestFitLine(logs: summaryLogs, metric: metric)
    }
    
    var body: some View {
        Chart {
            ForEach(summaryLogs, id: \.self) { data in
                PointMark(
                    x: .value("Date", data.avgStress),
                    y: .value("Stress", data[metric])
                )
                .symbol(.square)
                .foregroundStyle(Color("Sec"))
            } // ForEach
            
            LineMark(
                x: .value("Stress", bestFitLineCoordinates["MinX"]! ), //unwrap Double?
                y: .value("Metric", bestFitLineCoordinates["MinY"]! )
            )
            .lineStyle(.init(lineWidth: 1))
            .annotation(position: .top) {
                   Text("R² = \(bestFitLineCoordinates["R-Squared"]!)")
            }

            
            LineMark(
                x: .value("Stress", bestFitLineCoordinates["MaxX"]!),
                y: .value("Metric", bestFitLineCoordinates["MaxY"]!)
            )
            .lineStyle(.init(lineWidth: 1))
  

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
            
            AxisMarks(preset: .aligned, position: .leading,
                      values: [ 1, 2, 3, 4, 5, 6, 7, 8, 9], content: {
                
                AxisValueLabel()
                    .font(.system(10))
                    .foregroundStyle(Color("Sec")) // change the color for  readability
                
                
            })
            
            AxisMarks(
                preset: .aligned, position: .leading,
                values: [0, 10], content:
                    {
                        
                        AxisGridLine()
                            .foregroundStyle(Color("Sec"))
                        
                        AxisValueLabel()
                            .font(.system(10))
                            .foregroundStyle(Color("Sec")) // change the color for  readability
                    })
            
        }
        .font(.system(10))
        .foregroundStyle(Color("Sec"))
        .padding(30)
        .background(Color("Tint"))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width:350, height:350)
        
    }
}






