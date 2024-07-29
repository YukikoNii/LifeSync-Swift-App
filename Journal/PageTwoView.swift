//
//  2.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/24.
//

import SwiftUI

struct PageTwoView: View {

    @State private var happiness : Double = 0
    @State private var sleep : Double = 0
    @State private var activity : Double = 0
    @State private var school : Double = 0


    @State private var reflection = ""
        

    var body: some View {
        ZStack {
            
            Color("Color")
                .ignoresSafeArea()
            VStack {
                Text(Date(), style: .date)
                    .font(.system(40))
                    .padding()
                Divider()
                
                Text("Happiness: \(happiness, specifier:"%.0f")")
                    .padding()
                Slider(value: $happiness, in: 0...10, step:1,  minimumValueLabel: Text("0"),
                       maximumValueLabel: Text("10"),
                       label: { EmptyView() })
                .padding(.horizontal)
                
                Text("Sleep: \(sleep, specifier:"%.0f")")
                    .padding()
                Slider(value: $sleep, in: 0...10, step:1,  minimumValueLabel: Text("0"),
                       maximumValueLabel: Text("10"),
                       label: { EmptyView() })
                .padding(.horizontal)
                
                Text("Activity: \(activity, specifier:"%.0f")")
                    .padding()
                Slider(value: $activity, in: 0...10, step:1,  minimumValueLabel: Text("0"),
                       maximumValueLabel: Text("10"),
                       label: { EmptyView() })
                .padding(.horizontal)
                
                Text("School: \(school, specifier:"%.0f")")
                    .padding()
                Slider(value: $school, in: 0...10, step:1,  minimumValueLabel: Text("0"),
                       maximumValueLabel: Text("10"),
                       label: { EmptyView() })
                .padding(.horizontal)
                
                TextField("Anything else?", text: $reflection)
                    .padding()
                
                
                Button("Submit") {
                    //let newLog = dailyLog(logDate: Date(), Happiness: happiness)
                    //JournalModel.dailyLogs.append(newLog)
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.black)
            }
            .background(.ultraThinMaterial)
            .padding(10)
        }
    }
}

#Preview {
    PageTwoView()
}
