//
//  NewMeterCardView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 25.02.23.
//

import SwiftUI

struct MeterCardView: View {
    
//    var name: String = "Electric"
//    var icon: String = "powerplug"
//    var iconColor: Color = .red
    
    var meter: Meter
    
    let dateFormatter = DateFormatter()
    let myDate = Date()
    let myLocalizedStringKey = "date_Format"
    
    @State var startDateFormatted: String = ""
    @State var endDateFormatted: String = ""
    
//    init(name: String, icon: String, meter: Meter) {
//        self.meter = meter
//        self.name = name
//        self.icon = icon
//
//        let predicate = NSPredicate(format: "period == %@", meter)
//        _entries = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], predicate: predicate)
//    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: meter.icon ?? "circle")
                    .font(.title3)
    //                .padding(.horizontal)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.primary)
                VStack(alignment: .leading) {
                    Text(meter.name ?? "")
                        .font(.title)
                        .foregroundColor(.primary)
                    if let _ = getCurrentPeriod()?.startDate, let _ = getCurrentPeriod()?.endDate {
                        Text(String(format: NSLocalizedString("currentPeriod", comment: ""), startDateFormatted, endDateFormatted))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    } else {
                        Text("noCurrentPeriod")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            dateFormatter.dateFormat = NSLocalizedString(myLocalizedStringKey, comment: "")
            startDateFormatted = dateFormatter.string(from: getCurrentPeriod()?.startDate ?? Date())
            endDateFormatted = dateFormatter.string(from: getCurrentPeriod()?.endDate ?? Date())
            
        }
        .background(Color("ListItem"))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.linearGradient(colors: [.clear, .white.opacity(0.45), .clear, .white.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
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
