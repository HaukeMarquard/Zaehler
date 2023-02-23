//
//  PeriodListView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//

import SwiftUI

struct PeriodListView: View {
    
    let meter: Meter
    
    @StateObject private var viewModel: PeriodListViewModel = PeriodListViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                viewModel.setMeter(meter: meter)
            }
    }
}

//struct PeriodListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeriodListView()
//    }
//}
