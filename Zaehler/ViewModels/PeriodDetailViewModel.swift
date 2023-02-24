//
//  PeriodDetailViewModel.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//

import Foundation

class PeriodDetailViewModel: ObservableObject {
    
    var period: Period?
    
    @Published var entries: [Entry] = [Entry]()
    
    func setPeriod(period: Period) {
        self.period = period
        
        entries = period.entriesArray
    }
    
}
