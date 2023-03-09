//
//  AddEntryView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//

import SwiftUI

struct AddEntryView: View {
    
    var period: Period
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: AddEntryViewModel = AddEntryViewModel()
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            Form {
                NumericTextField(text: $viewModel.value, placeholder: String(localized: "entryValuePlaceholder"))
                    .focused($focusedField, equals: .first)
                DatePicker("entryDateDescription", selection: $viewModel.date, in: (period.startDate)...(period.endDate), displayedComponents: .date)
            }
            
            SaveAndCloseBtns(closeAction: dismiss, save: viewModel.saveEntry)
        }
        .onAppear {
            viewModel.setPeriod(period: period)
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

//struct AddEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEntryView()
//    }
//}
