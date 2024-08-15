
import SwiftUI
import SwiftData
import Foundation

struct LogView: View {
    @ObservedObject var viewModel: JournalViewModel

    var body: some View {
        ZStack {
            
            Color("Sec")
                .ignoresSafeArea()
            
            ScrollView {
                
                // Stress Tracker which you can log as many times as you want each day.
                StressTrackerView(viewModel: viewModel)
                
                // Daily log
                dailyLogView()
            
            }// scroll
            .frame(height:700)

        } // ZStack
    }
}


struct StressTrackerView: View {
    @ObservedObject var viewModel: JournalViewModel

    @State private var stressLevel : Double = 5
    @State private var stressDate = Date()
    @Environment(\.modelContext) var context

    
    var body: some View {
        VStack {
            Text("Stress Tracker") // TODO: include bold font.
                .font(.system(20))
            
            
            HStack {
                
                Text("Reset")
                    .onTapGesture{
                        stressDate = Date()
                    }
                    .padding()
                    .underline()
                
                
                DatePicker("", selection: $stressDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                    .colorScheme(.dark)
                    .padding()
                
            }
            
            Text("Stress Level: \(stressLevel, specifier:"%.0f")")
                .padding()
            //.frame(maxWidth:.infinity, alignment: .leading)
            //https://t32k.me/mol/log/text-align-swiftui/
            Slider(value: $stressLevel, in: 0...10, step:1,  minimumValueLabel: Text("Low"),
                   maximumValueLabel: Text("High"),
                   label: { EmptyView() })
            .padding(.horizontal)
            .tint(Color("Prim"))
            
            Button("Submit") {
                let newLog = stressLog(logDate: stressDate, stressLevel: stressLevel, id: UUID().uuidString)
                context.insert(newLog)
                stressLevel = 5
                
            } // Button
            .padding()
            .buttonStyle(.bordered)
            .tint(.white)
            
            
        }
        .padding()
        .font(.system(16))
        .foregroundStyle(Color("Prim"))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("Prim"), lineWidth: 4)
        )
        .padding(20)
    }
}

struct dailyLogView: View { // TODO: only allow one log per day.
    @Environment(\.modelContext) var context
    
    @State private var sleep : Double = 0
    @State private var activity : Double = 0
    @State private var work : Double = 0
    @State private var diet : Double = 0
    @State private var dateDaily = Date()
    @State private var journal = ""

    var body: some View {
        VStack {
            
            Text("Daily Log")
                .font(.system(20))
            
            DatePicker("", selection: $dateDaily, displayedComponents: [.date])
                .labelsHidden()
                .colorScheme(.dark)
                .padding()
            
            //https://zenn.dev/joo_hashi/books/ccb8a3799ce7ba/viewer/8ae4e2
            
            Divider()
            
            Text("Sleep: \(sleep, specifier:"%.1f") hours")
                .padding()
            Slider(value: $sleep, in: 0...10, step:0.5,  minimumValueLabel: Text("0"),
                   maximumValueLabel: Text("10h+"),
                   label: { EmptyView() })
            .padding(.horizontal)
            .tint(Color("Prim"))

            
            Text("Activity: \(activity, specifier:"%.0f")")
                .padding()
            Slider(value: $activity, in: 0...10, step:1,  minimumValueLabel: Text("Low"),
                   maximumValueLabel: Text("High"),
                   label: { EmptyView() })
            .padding(.horizontal)
            .tint(Color("Prim"))
            
            Text("Diet: \(activity, specifier:"%.0f")")
                .padding()
            Slider(value: $diet, in: 0...10, step:1,  minimumValueLabel: Text("Poor"),
                   maximumValueLabel: Text("Good"),
                   label: { EmptyView() })
            .padding(.horizontal)
            .tint(Color("Prim"))

            
            Text("Work: \(work, specifier:"%.0f")")
                .padding()
            Slider(value: $work, in: 0...10, step:1,  minimumValueLabel: Text("Low"),
                   maximumValueLabel: Text("High"),
                   label: { EmptyView() })
            .padding(.horizontal)
            .tint(Color("Prim"))

            
            Text("Journal")
            
            TextField("Anything else?", text: $journal)
                .padding()
            
            Button("Submit") {
                let dailyFactorsLog = dailyFactorsLog(sleep: sleep, activity: activity, diet: diet, work: work, journal: journal, logDate: dateDaily)
                context.insert(dailyFactorsLog)
                
            } // Button
            .padding()
            .buttonStyle(.bordered)
            .tint(.white)
            
        } // VStack
        .padding()
        .font(.system(16))
        .foregroundStyle(Color("Prim"))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("Prim"), lineWidth: 4)
        )
        .padding(20)
        
    }
}
