//
//  MeterCardView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//

import SwiftUI

struct MeterCardView: View {
    
    var name: String
    var icon: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                Text(name)
                Spacer()
            }
            .font(.title)
        }
    }
}

struct MeterCardView_Previews: PreviewProvider {
    static var previews: some View {
        MeterCardView(name: "Elektro", icon: "powerplug")
    }
}
