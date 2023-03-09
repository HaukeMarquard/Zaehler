//
//  SaveAndCloseBtns.swift
//  Zaehler
//
//  Created by Hauke Marquard on 09.03.23.
//

import SwiftUI

struct SaveAndCloseBtns: View {
    
    var closeAction: (DismissAction)
    var save: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center) {
            
            Button {
                closeAction()
            } label: {
                Text("buttonClose")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.3))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 10, x: 0.0, y: 10)
            }
            .buttonStyle(.withPresableButtonStyle())
            .padding(.horizontal, 20)
            
            Button {
                save()
                closeAction()
            } label: {
                Text("buttonSave")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.green.opacity(0.3))
                    .cornerRadius(10)
                    .shadow(color: .green.opacity(0.3), radius: 10, x: 0.0, y: 10)
            }
            .buttonStyle(.withPresableButtonStyle())
            .tint(.green)
            .padding(.horizontal, 20)
        }
    }
}

//struct SaveAndCloseBtns_Previews: PreviewProvider {
//    static var previews: some View {
//        SaveAndCloseBtns()
//    }
//}
