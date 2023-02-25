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
    
    init(entry: Entry, period: Period) {
        self.entry = entry
        self.period = period
    }
    
    var body: some View {
        VStack {
            Form {
                TextField("Value", text: $value)
                DatePicker("Date", selection: $date, in: (period.startDate ?? Date())...(period.endDate ?? Date()), displayedComponents: .date)
            }
            Button {
                saveEntry()
                dismiss()
            } label: {
                Text("Save Entry")
            }
            
        }
        .onAppear {
            value = "\(entry.value)"
            date = entry.date
        }
    }
    
    func saveEntry() {
        entry.value = Double(value) ?? 0.0
        entry.date = date
        PersistenceController.shared.save()
    }
}

//struct EditEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEntryView()
//    }
//}
