//
//  AddPeriodView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//

import SwiftUI

struct AddPeriodView: View {
    
    @StateObject var viewModel: AddPeriodViewModel = AddPeriodViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var meter: Meter
    
    @State private var containsFixPrice: Bool = true
    
    var body: some View {
        VStack {
            Form {
                Section("Zeitraum") {
                    DatePicker("Start", selection: $viewModel.startDate, displayedComponents:  .date)
                    DatePicker("End", selection: $viewModel.endDate, displayedComponents: .date)
                }
                Section("Fix Price") {
                    Toggle(isOn: $containsFixPrice) {
                        Text("Fix Price")
                    }
                    if containsFixPrice {
                        Picker(selection: $viewModel.fixPriceInterval, label: Text("Interval")) {
                            ForEach(FixPriceInterval.allCases, id: \.rawValue) { interval in
                                Text(interval.rawValue).tag(interval)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        TextField("Price", text: $viewModel.fixPrice)
                            .keyboardType(.numberPad)
                    }
                }
                Section("Consuming") {
                    TextField("Price per Unit", text: $viewModel.unitPrice)
                        .keyboardType(.numberPad)
                    Picker(selection: $viewModel.unitType, label: Text("Unit")) {
                        ForEach(UnitType.allCases, id: \.rawValue) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
            }
            HStack(alignment: .center) {
                Button {
                    viewModel.savePeriod()
                    dismiss()
                } label: {
                    Text("Add Period")
                }
                .padding()
                
            }
        }
        .onAppear {
            viewModel.setMeter(meter: meter)
        }
    }
}

//struct AddPeriodView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPeriodView()
//    }
//}
