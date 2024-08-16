//
//  SwiftUIView.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/30.
//

import SwiftUI
import SwiftData
import Foundation

struct HistoryView: View {
    
    @ObservedObject var viewModel: JournalViewModel
    @Environment(\.modelContext) private var context
    
    @Query(sort: \stressLog.logDate) var stressLogs: [stressLog]
    @Query(sort: \dailyFactorsLog.logDate) var dailyFactorsLogs: [dailyFactorsLog]
    @State var index = 0

    var body: some View {
        
        VStack {
            
            HStack {
                Text("Stress Logs")
                    .background(index == 0 ? Color("Var") : Color("Sec"))
                    .foregroundColor(index == 0 ? Color("Prim") : Color("Prim"))
                    .font(.system(17))
                    .clipShape(.rect(cornerRadius:5))
                    .onTapGesture {
                        index = 0
                    }
                
                Text("Daily Logs")
                    .background(index == 1 ? Color("Var") : Color("Sec"))
                    .foregroundColor(index == 1 ? Color("Prim") : Color("Prim"))
                    .font(.system(17))
                    .clipShape(.rect(cornerRadius:5))
                    .onTapGesture {
                        index = 1
                    }
            }
            
            
            TabView(selection: $index) {
                List {
                    ForEach(stressLogs) { log in
                        VStack (alignment: .leading){
                            HStack {
                                
                                NavigationLink {
                                } label: {
                                    Text("\(log.logDate.formatted(date:.abbreviated, time:.shortened))")
                                        .foregroundStyle(Color("Sec"))
                                }
                            }
                            HStack {
                                Text("Stress Level: \(String(format: "%.2f", log.stressLevel))") // round to 2dp
                                    .foregroundStyle(Color("Sec"))
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                context.delete(log)
                            }
                            .tint(.red)
                        }
                        .swipeActions(edge: .leading) {
                            Button ("Edit") {
                            }
                            .tint(.yellow)
                        }
                        .listRowBackground(Color("Prim"))
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color("Sec"))
                .foregroundStyle(.white)
                .tag(0)
                
                List {
                    ForEach(dailyFactorsLogs, id: \.self) { log in
                        VStack (alignment: .leading){
                            HStack {
                                
                                NavigationLink {
                                } label: {
                                    Text("\(log.logDate.formatted(date:.abbreviated, time:.shortened))")
                                        .foregroundStyle(Color("Sec"))
                                }
                            }
                            VStack {
                                Text("Sleep: \(String(format: "%.2f", log.sleep))") // round to 2dp
                                    .foregroundStyle(Color("Sec"))
                                
                                Text("Activity: \(String(format: "%.2f", log.activity))")
                                    .foregroundStyle(Color("Sec"))
                                
                                Text("Diet: \(String(format: "%.2f", log.diet))")
                                    .foregroundStyle(Color("Sec"))
                                
                                Text("Work: \(String(format: "%.2f", log.work))")
                                    .foregroundStyle(Color("Sec"))
                                
                                Text("Sleep: \(String(format: "%.2f", log.journal))")
                                    .foregroundStyle(Color("Sec"))
                                
                                Text("Journal: \(log.journal)")
                                    .foregroundStyle(Color("Sec"))
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                context.delete(log)
                            }
                            .tint(.red)
                        }
                        .swipeActions(edge: .leading) {
                            Button ("Edit") {
                            }
                            .tint(.yellow)
                        }
                        .listRowBackground(Color("Prim"))
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color("Sec"))
                .foregroundStyle(.white)
                .tag(1)
            } // TabView
        } // VStack
    } // body
} // HistoryView


