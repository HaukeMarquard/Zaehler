//
//  NewMeterCardView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 25.02.23.
//

import SwiftUI

struct NewMeterCardView: View {
    
//    var name: String = "Electric"
//    var icon: String = "powerplug"
//    var iconColor: Color = .red
    
    var meter: Meter
    
//    init(name: String, icon: String, meter: Meter) {
//        self.meter = meter
//        self.name = name
//        self.icon = icon
//
//        let predicate = NSPredicate(format: "period == %@", meter)
//        _entries = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], predicate: predicate)
//    }
    
    
    var body: some View {
        HStack {
            Image(systemName: meter.icon ?? "circle")
                .font(.title3)
//                .padding(.horizontal)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text(meter.name ?? "")
                    .font(.title)
                Text("Aktueller Zeitraum: \((getCurrentPeriod()?.startDate ?? Date()).formatted(date: .abbreviated, time: .omitted)) - \((getCurrentPeriod()?.endDate ?? Date()).formatted(date: .abbreviated, time: .omitted))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func getCurrentPeriod() -> Period? {
            let now = Date()
            let predicate = NSPredicate(format: "startDate <= %@ AND endDate >= %@", now as NSDate, now as NSDate)
            let sortedPeriods = meter.periods?.sortedArray(using: [NSSortDescriptor(keyPath: \Period.startDate, ascending: false)]) as? [Period]
            return sortedPeriods?.first(where: { predicate.evaluate(with: $0) })
        }
}

//struct NewMeterCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewMeterCardView()
//    }
//}
