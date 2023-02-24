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
    
    var body: some View {
        VStack {
            Form {
                TextField("Value", text: $viewModel.value)
                DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
            }
            Button {
                viewModel.saveEntry()
                dismiss()
            } label: {
                Text("Save Entry")
            }
        }
        .onAppear {
            viewModel.setPeriod(period: period)
        }
    }
}

//struct AddEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEntryView()
//    }
//}
