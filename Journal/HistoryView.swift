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
    
    @Query(sort: \stressLog.logDate) var logs: [stressLog]

    var body: some View {
        
        
        List {
            ForEach(logs) { log in
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
    }
}


