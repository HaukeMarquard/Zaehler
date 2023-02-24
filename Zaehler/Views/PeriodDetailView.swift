//
//  PeriodDetailView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//

import SwiftUI

struct PeriodDetailView: View {
    
    var period: Period
    
    @StateObject var viewModel: PeriodDetailViewModel = PeriodDetailViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "circle")
                Text("Meter Title")
            }
            .font(.title)
            Text("Period von - Period bis")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Chart
            
            // Entry List
            List {
                ForEach(viewModel.entries) { entry in
                    VStack {
                        Text("\(entry.date.formatted(date: .abbreviated, time: .omitted))")
                        Text("\(entry.value)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            .listStyle(.plain)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addButton()
            }
        }
        .onAppear {
            viewModel.setPeriod(period: period)
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {

        NavigationLink {
//            AddEntryView()
        } label: {
            Image(systemName: "plus.circle")
                .font(.title3)
        }
        .padding([.vertical, .leading], 5)
    }
}

//struct PeriodDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeriodDetailView()
//    }
//}
