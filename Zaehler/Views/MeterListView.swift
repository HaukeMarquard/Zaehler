//
//  MeterListView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//

import SwiftUI

struct MeterListView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var meters: FetchedResults<Meter>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    ForEach(meters) { meter in
                        Text(meter.name ?? "")
                    }
                    .onDelete { indexSet in
                        print("Delete")
                    }
                }
            }
            .navigationTitle("Zähler")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton()
                }
            }
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {

        NavigationLink {
            AddMeterView()
        } label: {
            Image(systemName: "plus.circle")
                .font(.title3)
        }
        .padding([.vertical, .leading], 5)
    }
}

struct MeterListView_Previews: PreviewProvider {
    static var previews: some View {
        MeterListView()
    }
}
