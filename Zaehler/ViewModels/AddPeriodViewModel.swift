//
//  AddPeriodViewModel.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//

import Foundation

enum FixPriceInterval: String, CaseIterable {
    case monthly = "month"
    case quarterly = "quarter"
    case halfYearly = "halfYear"
    case yearly = "year"
}
enum UnitType: String, CaseIterable {
    case kwh = "kWh"
    case liter = "liter"
    case m3 = "m3"
}

class AddPeriodViewModel: ObservableObject {
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var unitPrice: String = ""
    @Published var unitType: UnitType = .kwh
    @Published var fixPriceInterval: FixPriceInterval? = .monthly
    @Published var fixPrice: String = ""
    
    @Published var containsFixPrice: Bool = true
    
    var meter: Meter?
    
    func setMeter(meter: Meter) {
        self.meter = meter
    }
    
    func savePeriod() {
        createNewPeriod()
    }
    
    func createNewPeriod() {
        let newPeriod = Period(context: PersistenceController.shared.viewContext)
        newPeriod.startDate = startDate
        newPeriod.endDate = endDate
        newPeriod.unitPrice = Double(unitPrice) ?? 0.0
        newPeriod.unitType = unitType.rawValue
        if containsFixPrice {
            newPeriod.fixPriceInterval = fixPriceInterval?.rawValue
        } else {
            newPeriod.fixPriceInterval = nil
        }
        
        newPeriod.fixPrice = Double(fixPrice) ?? 0.0
        
        meter?.addToPeriods(newPeriod)
        
        
        PersistenceController.shared.save()
    }
    
//    func setFixPriceInterval(_ interval: FixPriceInterval) {
//        self.fixPriceInterval = interval.rawValue
//    }
    
//    func setUnitType(_ unitType: UnitType) {
//        self.unitType = unitType.rawValue
//    }
}
