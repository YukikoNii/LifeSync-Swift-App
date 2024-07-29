//
//  SwiftUIView.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/24.
//

import SwiftUI
import Charts

struct PageOneView: View {
    
    @ObservedObject var viewModel: JournalViewModel

    @State var index = 0

    var body: some View {
                        
        
    //https://www.youtube.com/watch?app=desktop&v=dRdguneAh8M

        ZStack {
            Color("Color")
                .ignoresSafeArea()// 背景
            
            VStack {
                
    
                Text("Hello, \(viewModel.name)")
                        .fontWeight(.heavy)
                        .font(.system(30))
                
                Divider()
                
                ScrollView(.horizontal) {
                    HStack {
                        
                        Text("Overview")
                            .padding()
                            .background(index == 0 ? Color.black : Color("Color"))
                            .foregroundColor(.white)
                            .tint(.black)
                            .font(.system(18))

                            .onTapGesture {
                                
                                index = 0
                            }
                        
                        ForEach(overviewTiles, id: \.self) { indicator in
                            
                            Text(indicator.name)
                                .padding()
                                .background(index == indicator.id + 1 ? Color.black : Color("Color"))
                                .foregroundColor(.white)
                                .tint(.black)
                                .font(.system(18))
                            
                                .onTapGesture {
                                    
                                    index = indicator.id + 1
                                }
                        }
                        
                        Text("Analysis")
                            .padding()
                            .background(index == 5 ? Color.black : Color("Color"))
                            .foregroundColor(.white)
                            .tint(.black)
                            .font(.system(18))
                            .onTapGesture {
                                
                                index = 5
                            }
                    }
                }
                
                Divider()
                
                //https://zenn.dev/usk2000/articles/68c4c1ec7944fe
                
                TabView (selection: $index) {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            
                            ForEach(overviewTiles, id: \.self) { indicator in
                                
                                ZStack {
                                    // make local variable to avoid repetition
                                    VStack {
                                        Text(indicator.name)
                                            .font(.system(20))
                                        Divider()
                                        Text(indicator.stat)
                                            .font(.system(27))
                                    }
                                }
                                .padding(35)
                                .background(.ultraThinMaterial)
                                .aspectRatio(1, contentMode:.fit)
                            }
                        }
                        .tag(0)// LazyVGrid
                    } // ScrollView
                    
                    ChartView()
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                
            } // VStack
            .foregroundStyle(.white)
            .padding(15)
            
            

                
            } // ZStack

    } // body
    
    
    struct Indicator: Identifiable, Hashable {
        
        var name:String
        var stat: String
        var id: Int

    }
    
    var overviewTiles = [
        Indicator(name: "Happiness", stat: "6/10", id:0),
        Indicator(name: "Sleep", stat: "8h 30m", id:1),
        Indicator(name: "Exercise", stat: "30m", id:2),
        Indicator(name: "Diet", stat: "Poor", id:2),
        Indicator(name: "Work", stat: "Stressed", id:3)
    ]
}

struct ChartView: View {
  var body: some View {
    Chart {
        LineMark(
        x: .value("Date", "7/24"),
        y: .value("Coffee", 8)
        )
        LineMark(
        x: .value("Date", "7/25"),
        y: .value("Coffee", 4)
        )
    }
  }
}

#Preview {
    PageOneView(viewModel: JournalViewModel())
}
