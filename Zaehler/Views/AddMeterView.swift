//
//  NewAddMeterView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 06.03.23.
//

import SwiftUI

struct AddMeterView: View {
    
    @State var name: String = ""
    @State var meterid: String = ""
    
    @StateObject private var viewModel: AddMeterViewModel = AddMeterViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Meter Name")
                .font(.footnote)
                .foregroundColor(.primary)
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(.plain)
                .padding(.bottom)
            
            Text("Meter ID")
                .font(.footnote)
                .foregroundColor(.primary)
            TextField("ID", text: $viewModel.meterNumber)
                .textFieldStyle(.plain)
                .padding(.bottom)
            
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    ForEach(PossibleIcons.allCases, id: \.self) { icon in

                            Button {
                                withAnimation {
                                    viewModel.setIcon(icon)
                                }
                            } label: {
                                Image(systemName: icon.rawValue)
                            }
                            .foregroundColor(viewModel.icon == icon.rawValue ? Color.accentColor : .primary)
                            .frame(width: 30, height: 30)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(
//                                        Color(UIColor.systemBackground)
                                        Color("ListItem")
                                            .shadow(
                                                .drop(color: viewModel.icon == icon.rawValue ? Color.accentColor : colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.8), radius: 2, x: 1, y: 1)))
                                }
                            .padding(8)
                        
                    }
                    Spacer()
                }
            }
            
            SaveAndCloseBtns(closeAction: dismiss, save: viewModel.save)
            .padding(.top)
            
            
        }
        .padding()
        
    }
}

struct AddMeterView_Previews: PreviewProvider {
    static var previews: some View {
        AddMeterView()
    }
}
