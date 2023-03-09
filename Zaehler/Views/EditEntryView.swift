//
//  EditEntryView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 25.02.23.
//

import SwiftUI

struct EditEntryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var entry: Entry
    var period: Period
    
    @State private var value: String = "50"
    @State private var date: Date = Date()
    
    @FocusState private var focusedField: Field?
    
    init(entry: Entry, period: Period) {
        self.entry = entry
        self.period = period
    }
    
    var body: some View {
        VStack {
            Form {
                NumericTextField(text: $value, placeholder: String(localized: "entryValuePlaceholder"))
                    .focused($focusedField, equals: .first)
                DatePicker("entryDateDescriptor", selection: $date, in: (period.startDate)...(period.endDate), displayedComponents: .date)
            }
            SaveAndCloseBtns(closeAction: dismiss, save: saveEntry)
        }
        .onAppear {
            value = doubleToString(entry.value)
            date = entry.date
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
    
    func saveEntry() {
        entry.value = Double(value.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        entry.date = date
        PersistenceController.shared.save()
    }
}

//struct EditEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEntryView()
//    }
//}
