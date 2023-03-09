//
//  EditMeterView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 09.03.23.
//

import SwiftUI

struct EditMeterView: View {
    
    @State var name: String = ""
    @State var meterNumber: String = ""
    @State var meterIcon: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var meter: Meter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Meter Name")
                .font(.footnote)
                .foregroundColor(.primary)
            TextField("Name", text: $name)
                .textFieldStyle(.plain)
                .padding(.bottom)
            
            Text("Meter ID")
                .font(.footnote)
                .foregroundColor(.primary)
            TextField("ID", text: $meterNumber)
                .textFieldStyle(.plain)
                .padding(.bottom)
            
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    ForEach(PossibleIcons.allCases, id: \.self) { icon in

                            Button {
                                withAnimation {
                                    meterIcon = icon.rawValue
                                }
                            } label: {
                                Image(systemName: icon.rawValue)
                            }
                            .foregroundColor(meterIcon == icon.rawValue ? Color.accentColor : .primary)
                            .frame(width: 30, height: 30)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(
//                                        Color(UIColor.systemBackground)
                                        Color("ListItem")
                                            .shadow(
                                                .drop(color: meterIcon == icon.rawValue ? Color.accentColor : colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.8), radius: 2, x: 1, y: 1)))
                                }
                            .padding(8)
                        
                    }
                    Spacer()
                }
            }
            
            SaveAndCloseBtns(closeAction: dismiss, save: save)
            .padding(.top)
            
            
        }
        .padding()
        .onAppear {
            name = meter.name ?? ""
            meterIcon = meter.icon ?? ""
            meterNumber = meter.meterNumber ?? ""
        }
    }
    
    func save() {
        meter.name = name
        meter.icon = meterIcon
        meter.meterNumber = meterNumber
        
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Save of edited Meter throw an error: \(error)")
        }
    }
}

//struct EditMeterView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditMeterView()
//    }
//}
