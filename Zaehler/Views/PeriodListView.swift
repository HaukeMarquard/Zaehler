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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var actualPeriods: FetchedResults<Period>
    
    @FetchRequest var otherPeriods: FetchedResults<Period>
    
    init(meter: Meter) {
        self.meter = meter
        
        let predicateActual = NSPredicate(format: "meter == %@ AND %K <= %@ AND %K >= %@", meter, #keyPath(Period.startDate), Date() as NSDate, #keyPath(Period.endDate), Date() as NSDate)
        _actualPeriods = FetchRequest(sortDescriptors: [], predicate: predicateActual)
        
        let predicateOther = NSPredicate(format: "meter == %@ AND %K < %@ OR %K > %@", meter, #keyPath(Period.endDate), Date() as NSDate, #keyPath(Period.startDate), Date() as NSDate)
        _otherPeriods = FetchRequest(sortDescriptors: [], predicate: predicateOther)
    }
    
    var body: some View {
        VStack {
            
            List {
                Section("actualPeriodSectionHeader") {
                    ForEach(actualPeriods) { period in
                        NavigationLink {
                            PeriodDetailView(period: period, icon: meter.icon ?? "circle", name: meter.name ?? "")
                        } label: {
                            Text("\((period.startDate).formatted(date: .abbreviated, time: .omitted)) - \((period.endDate).formatted(date: .abbreviated, time: .omitted))")
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let period = actualPeriods[index]
                            viewContext.delete(period)
                        }
                        PersistenceController.shared.save()
                    }
                }
                
                Section ("otherPeriodSectionHeader") {
                    ForEach(otherPeriods) { period in
                        NavigationLink {
                            PeriodDetailView(period: period, icon: meter.icon ?? "circle", name: meter.name ?? "")
                        } label: {
                            Text("\((period.startDate).formatted(date: .abbreviated, time: .omitted)) - \((period.endDate).formatted(date: .abbreviated, time: .omitted))")
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let period = otherPeriods[index]
                            viewContext.delete(period)
                        }
                        PersistenceController.shared.save()
                    }
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
        .navigationTitle(meter.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func getCurrentPeriod() -> Period? {
            let now = Date()
            let predicate = NSPredicate(format: "startDate <= %@ AND endDate >= %@", now as NSDate, now as NSDate)
            let sortedPeriods = meter.periods?.sortedArray(using: [NSSortDescriptor(keyPath: \Period.startDate, ascending: false)]) as? [Period]
            return sortedPeriods?.first(where: { predicate.evaluate(with: $0) })
    }
    
    @ViewBuilder
    private func addButton() -> some View {

        NavigationLink {
            AddPeriodView(meter: meter)
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
