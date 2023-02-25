//
//  MeterCardWithoutPeriodView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//

import SwiftUI

struct MeterCardWithoutPeriodView: View {
    
    var name: String
    var icon: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                Text(name)
                Spacer()
            }
            Text("No current period created.")
        }
    }
}

struct MeterCardWithoutPeriodView_Previews: PreviewProvider {
    static var previews: some View {
        MeterCardWithoutPeriodView(name: "Strom", icon: "circle")
    }
}
