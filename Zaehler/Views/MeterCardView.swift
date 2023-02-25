//
//  MeterCardView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//

import SwiftUI

struct MeterCardView: View {
    
    var name: String
    var icon: String
    
    var period: Period
    
    @FetchRequest var entries: FetchedResults<Entry>
    
    init(name: String, icon: String, period: Period) {
        self.period = period
        self.name = name
        self.icon = icon
        
        let predicate = NSPredicate(format: "period == %@", period)
        _entries = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], predicate: predicate)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                Text(name)
                Spacer()
            }
            .font(.title)
            if let period = period {
                Text("\((period.startDate ?? Date()).formatted(date: .abbreviated, time: .omitted)) - \((period.endDate ?? Date()).formatted(date: .abbreviated, time: .omitted))")
                Text("Gesamtverbrauch: \(String(format: "%.2f", calculateWholeConsumption())) \(period.unitType ?? "")")
                Text("Verbrauch pro Tag: \(String(format: "%.2f", calculateDailyConsumption())) \(period.unitType ?? "")")
                
            }
        }
    }
    
    func calculateWholeConsumption() -> Double {
        guard let first = entries.first, let last = entries.last else { return 0.0 }
        
        let sum = first.value - last.value
        return sum
        
    }
    
    func calculateDailyConsumption() -> Double {
        guard let first = entries.first, let last = entries.last else { return 0.0 }
        
        guard let difference = Calendar.current.dateComponents([.day], from: first.date, to: last.date ).day else { return 0.0 }
        
        return calculateWholeConsumption() / Double(difference + 2)
        
    }

}

//struct MeterCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeterCardView(name: "Elektro", icon: "powerplug")
//    }
//}
