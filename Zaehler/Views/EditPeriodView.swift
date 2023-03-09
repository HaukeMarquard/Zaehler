//
//  EditPeriodView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 08.03.23.
//

import SwiftUI

struct EditPeriodView: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var period: Period
    
    @State var unitPrice: String = ""
    @State var fixPrice: String = ""
    @State var containsFixPrice: Bool = false
//    @State var fixPriceInterval: String = FixPriceInterval.monthly.rawValue
    @State var fixPriceInterval: FixPriceInterval = FixPriceInterval.monthly
    @State var unitType: UnitType = UnitType.kwh
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    
    var body: some View {
        
        VStack {
            
            Form {
                Section("periodSectionHeader") {
                    DatePicker("periodBegin", selection: $startDate, displayedComponents:  .date)
                    DatePicker("periodEnd", selection: $endDate, in: (startDate)... , displayedComponents: .date)
                }
                
                Section("fixPriceSectionHeader") {
                    Toggle(isOn: $containsFixPrice) {
                        Text("fixPriceToggle")
                    }
                    if containsFixPrice {
                        Picker(selection: $fixPriceInterval, label: Text("Interval")) {
                            ForEach(FixPriceInterval.allCases, id: \.rawValue) { interval in
                                Text(interval.rawValue).tag(interval)
                            }
                        }
                        .pickerStyle(.segmented)
                        NumericTextField(text: $fixPrice, placeholder: String(localized: "fixPriceValuePlaceholder"))
                    }
                }
                
                Section("consumptionValuePlaceholder") {
                    NumericTextField(text: $unitPrice, placeholder: String(localized: "consumptionValuePlaceholder"))
                    Picker(selection: $unitType, label: Text("Unit")) {
                        ForEach(UnitType.allCases, id: \.rawValue) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                }
            }
            
            SaveAndCloseBtns(closeAction: dismiss, save: savePeriod)
        }
        .onAppear {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            unitPrice = formatter.string(from: NSNumber(value: period.unitPrice)) ?? "0"
            unitType = UnitType(rawValue: period.unitType) ?? .kwh
            fixPrice = formatter.string(from: NSNumber(value: period.fixPrice)) ?? "0"
            if period.fixPriceInterval != nil {
                fixPriceInterval = FixPriceInterval(rawValue: period.fixPriceInterval ?? "") ?? .monthly
            }
            containsFixPrice = period.fixPriceInterval != nil
            startDate = period.startDate
            endDate = period.endDate
        }
        
        
    }
    
    func savePeriod() {
        if containsFixPrice {
            period.fixPriceInterval = fixPriceInterval.rawValue
            period.fixPrice = Double(fixPrice.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        }
        period.unitPrice = Double(unitPrice.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        period.unitType = unitType.rawValue
        period.startDate = startDate
        period.endDate = endDate
        
        do {
            try viewContext.save()
        } catch {
            print("Delete of Meter was not successful")
            viewContext.rollback()
        }
    }
}

//struct EditPeriodView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPeriodView()
//    }
//}
