//
//  PeriodListViewModel.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//

import Foundation

class PeriodListViewModel: ObservableObject {
    
    var meter: Meter?
    
    @Published var periods: [Period] = [Period]()
    
    func setMeter(meter: Meter) {
        self.meter = meter
        
        periods = meter.periodsArray
    }
    
}
