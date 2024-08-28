

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
        .font(.system(18))
        .foregroundStyle(Color("Sec"))
    }
}


struct ChartView: View {
    
    let summaryLogs: [summaryLog]
    let metric: String
    
    var bestFitLineCoordinates: [String: [Double]]  {
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
                x: .value("Stress", bestFitLineCoordinates["Min"]![0] ), //unwrap Double?
                y: .value("Metric", bestFitLineCoordinates["Min"]![1] )
            )
            .lineStyle(.init(lineWidth: 1))
            .annotation(position: .overlay) {
                   Text("r^2 = \(bestFitLineCoordinates["R-Squared"]![0])") // TODO: bring to the foremost layer
            }

            
            LineMark(
                x: .value("Stress", bestFitLineCoordinates["Max"]![0] ),
                y: .value("Metric", bestFitLineCoordinates["Max"]![1] )
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


func calculateBestFitLine(logs: [summaryLog], metric: String) -> [String: [Double]] {
    let n = Double(logs.count)
    
    let xValues = logs.map { $0.avgStress }
    let yValues = logs.map { $0[metric] }

    let sumX = logs.reduce(0.0) { $0 + $1.avgStress }
    let sumY = logs.reduce(0.0) { $0 + $1[metric] }
    
    let sumXY = logs.reduce(0.0) { $0 + $1.avgStress * $1[metric] }
    let sumX2 = logs.reduce(0.0) { $0 + pow($1.avgStress, 2) }
     
    let slope = ( (sumXY * n - (sumX * sumY))  / ( sumX2 * n - (sumX * sumX)) )
    
    let intercept = ( sumY - slope * sumX ) / n
    
    let minStress = logs.map { $0.avgStress }.min() ?? 0
    let maxStress = logs.map { $0.avgStress }.max() ?? 1
        
    let yMean = sumY / n
    
    let predictedYValues = xValues.map { slope * $0 + intercept }
    
    // sst = Total sum of squares
    let sst = yValues.reduce(0) { $0 + pow($1 - yMean, 2) }
    
    // ssr = residual sum of squares
    let ssr = zip(predictedYValues, yValues).reduce(0.0) { $0 + pow($1.0 - $1.1, 2) }

    let rSquared = 1 - (ssr / sst)
    
    let bestFitLineCoordinates: [String: [Double]] = [
        "Min": [minStress, slope*minStress + intercept],
        "Max": [maxStress, slope*maxStress + intercept],
        "R-Squared": [rSquared],
    ]
    
    return bestFitLineCoordinates
}



