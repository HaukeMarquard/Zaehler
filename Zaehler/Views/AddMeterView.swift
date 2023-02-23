//
//  AddMeterView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//

import SwiftUI

struct AddMeterView: View {
    
    @StateObject private var viewModel: AddMeterViewModel = AddMeterViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Meter ID", text: $viewModel.meterNumber)
                .textFieldStyle(.roundedBorder)
            
            Text("Icon")
            HStack(alignment: .center) {
                ForEach(PossibleIcons.allCases, id: \.self) { icon in
                    Button {
                        viewModel.setIcon(icon)
                    } label: {
                        Image(systemName: icon.rawValue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .border(.secondary)
                    .background(viewModel.icon == icon.rawValue ? .red : .gray)
                }
            }
            Button {
                viewModel.save()
                dismiss()
            } label: {
                Text("Save")
            }
        }
    }
}

struct AddMeterView_Previews: PreviewProvider {
    static var previews: some View {
        AddMeterView()
    }
}
