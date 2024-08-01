//
//  JournalViewModel.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/24.
//

import SwiftUI

class JournalViewModel: ObservableObject {
    
    //@Published private var model = journalModel()

    @Published var name = "Bob"
    
    @Published var username = ""
    
    @Published var email = ""
    
    @Published var password = ""
    
}




