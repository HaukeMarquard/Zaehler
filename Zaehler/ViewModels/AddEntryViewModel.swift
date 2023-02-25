//
//  AddEntryViewModel.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//

import Foundation

class AddEntryViewModel: ObservableObject {
    
    @Published var value: String = ""
    @Published var date: Date = Date()
    
    var period: Period?
    
    func setPeriod(period: Period) {
        self.period = period
    }
    
    func saveEntry() {
        let newEntry = Entry(context: PersistenceController.shared.viewContext)
        newEntry.value = Double(value) ?? 0.0
        newEntry.date = date
        
        period?.addToEntries(newEntry)
        
        PersistenceController.shared.save()
    }
    
}
