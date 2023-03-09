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
                    ForEach(meters) { meter in
                        if let _ = meter.getActuralPeriod() {
                            NavigationLink {
                                PeriodListView(meter: meter)
                            } label: {
                                MeterCardView(meter: meter)
                                    .contextMenu {
                                        deleteButton(meter: meter)
                                    }
                            }
                        } else {
                            NavigationLink {
                                PeriodListView(meter: meter)
                            } label: {
                                MeterCardView(meter: meter)
                                    .contextMenu {
                                        deleteButton(meter: meter)
                                    }
                            }
                        }
                    }
            }
            .padding(.top, 20)
            Spacer()
            .navigationTitle("meterListTitle")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton()
                }
            }
        }
    }
    
    @ViewBuilder
    private func deleteButton(meter: Meter) -> some View {
        Button {
            viewContext.delete(meter)
            
            do {
                try viewContext.save()
            } catch {
                print("Delete of Meter was not successful")
                viewContext.rollback()
            }
        } label: {
            Label("buttonDeleteMeter", systemImage: "trash")
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
