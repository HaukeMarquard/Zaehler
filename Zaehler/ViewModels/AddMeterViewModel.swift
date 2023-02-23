//
//  AddMeterViewModel.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//

import Foundation

class AddMeterViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var meterNumber: String = ""
    @Published var icon: String = ""
    
    var possibleIcons: PossibleIcons = .powerplug
    
    func setIcon(_ icon: PossibleIcons) {
        self.icon = icon.rawValue
    }
    
    func save() {
        let meter = Meter(context: PersistenceController.shared.container.viewContext)
        meter.name = name
        meter.meterNumber = meterNumber
        meter.icon = icon
        
        PersistenceController.shared.save()
    }
    
}

enum PossibleIcons: String, CaseIterable {
    case powerplug = "powerplug"
    case drop = "drop.fill"
    case flame = "flame"
    case spigot = "spigot"
}
