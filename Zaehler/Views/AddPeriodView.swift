//
//  AddPeriodView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//

import SwiftUI
import Combine

struct AddPeriodView: View {
    
    @StateObject var viewModel: AddPeriodViewModel = AddPeriodViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedField: Field?
    
    var meter: Meter    
    
    var body: some View {
        VStack {
            Form {
                Section("periodSectionHeader") {
                    DatePicker("periodBegin", selection: $viewModel.startDate ,displayedComponents:  .date)
                    DatePicker("periodEnd", selection: $viewModel.endDate, in: (viewModel.startDate)... ,displayedComponents: .date)
                }
                Section(LocalizedStringKey("fixPriceSectionHeader")) {
                    Toggle(isOn: $viewModel.containsFixPrice) {
                        Text(LocalizedStringKey("fixPriceToggle"))
                    }
                    if viewModel.containsFixPrice {
                        Picker(selection: $viewModel.fixPriceInterval, label: Text("Interval")) {
                            ForEach(FixPriceInterval.allCases, id: \.rawValue) { interval in
                                Text(interval.rawValue).tag(interval)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        NumericTextField(text: $viewModel.fixPrice, placeholder: String(localized: "fixPriceValuePlaceholder"))
                            .focused($focusedField, equals: .first)
                    }
                }
                Section("consumptionSectionHeader") {
                    NumericTextField(text: $viewModel.unitPrice, placeholder: String(localized: "consumptionValuePlaceholder"))
                        .focused($focusedField, equals: .second)
                    Picker(selection: $viewModel.unitType, label: Text("Unit")) {
                        ForEach(UnitType.allCases, id: \.rawValue) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
            }
            SaveAndCloseBtns(closeAction: dismiss, save: viewModel.savePeriod)
        }
        .onAppear {
            viewModel.setMeter(meter: meter)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
    
}

//struct AddPeriodView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPeriodView()
//    }
//}



