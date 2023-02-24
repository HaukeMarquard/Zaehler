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
        VStack {
            List {
                ForEach(viewModel.periods, id: \.objectID) { period in
                    Text("\(period.startDate ?? Date()) - \(period.endDate ?? Date())")
                }
            }
        }
        .onAppear {
            viewModel.setMeter(meter: meter)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addButton()
            }
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {

        NavigationLink {
            AddPeriodView()
        } label: {
            Image(systemName: "plus.circle")
                .font(.title3)
        }
        .padding([.vertical, .leading], 5)
    }
}

//struct PeriodListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeriodListView()
//    }
//}
