//
//  MeterListView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//

import SwiftUI

struct MeterListView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var meters: FetchedResults<Meter>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    ForEach(meters) { meter in
                        
                        if let _ = meter.getActuralPeriod() {
                            NavigationLink {
                                PeriodListView(meter: meter)
                            } label: {
                                NewMeterCardView(meter: meter)
                            }
                            
                            
                            
                        } else {
                            NavigationLink {
                                PeriodListView(meter: meter)
                            } label: {
                                MeterCardWithoutPeriodView(
                                    name: meter.name ?? "",
                                    icon: meter.icon ?? ""
                                )
                            }
                        }
                    }
                    .onDelete { indexSet in
                        print("Delete")
                    }
                }
                .listStyle(.plain)
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
            .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
    }
}
