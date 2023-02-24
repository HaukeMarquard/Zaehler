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
    @Published var fixPriceInterval: FixPriceInterval = .monthly
    @Published var fixPrice: String = ""
    
    func setMeter(meter: Meter) {
        
    }
    
//    func setFixPriceInterval(_ interval: FixPriceInterval) {
//        self.fixPriceInterval = interval.rawValue
//    }
    
//    func setUnitType(_ unitType: UnitType) {
//        self.unitType = unitType.rawValue
//    }
}
