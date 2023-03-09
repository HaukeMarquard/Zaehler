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
    @Published var wholeConsumption: Double = 0.0
    @Published var daylyConsumption: Double = 0.0
    @Published var wholePrice: Double = 0.0
    
    func setPeriod(period: Period) {
        self.period = period
        
        entries = period.entriesArray
        wholeConsumption = calculateWholeConsumption()
        daylyConsumption = calculateDailyConsumption()
        calculateWholePrice()
    }
    
    func calculateWholeConsumption() -> Double {
        guard let first = entries.first, let last = entries.last else { return 0.0 }
    
        let sum = last.value - first.value
        return sum
        
    }
    
    func calculateDailyConsumption() -> Double {
        guard let first = entries.first, let last = entries.last else { return 0.0 }
        
        guard let difference = Calendar.current.dateComponents([.day], from: first.date, to: last.date ).day else { return 0.0 }
        
        return calculateWholeConsumption() / Double(difference + 2)
        
    }
    
    func calculateWholePrice() {
        
        let wholeConsumption = calculateWholeConsumption()
        
        guard let period = period else { return }
        
        wholePrice = wholeConsumption * period.unitPrice
        
    }
    
    func deleteEntry(index: IndexSet) {
        
        for i in index {
            let entry = entries[i]
            PersistenceController.shared.viewContext.delete(entry)
            PersistenceController.shared.save()
        }
        
        
        
    }
    
}
