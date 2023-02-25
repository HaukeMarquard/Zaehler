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
                Section("Actual Period") {
                    ForEach(actualPeriods) { period in
                        NavigationLink {
                            PeriodDetailView(period: period, icon: meter.icon ?? "circle", name: meter.name ?? "")
                        } label: {
                            Text("\((period.startDate ?? Date()).formatted(date: .abbreviated, time: .omitted)) - \((period.endDate ?? Date()).formatted(date: .abbreviated, time: .omitted))")
                        }
                    }
                }
                
                Section ("Other Period") {
                    ForEach(otherPeriods) { period in
                        NavigationLink {
                            PeriodDetailView(period: period, icon: meter.icon ?? "circle", name: meter.name ?? "")
                        } label: {
                            Text("\((period.startDate ?? Date()).formatted(date: .abbreviated, time: .omitted)) - \((period.endDate ?? Date()).formatted(date: .abbreviated, time: .omitted))")
                        }
                    }
                }
            }
            
            
//            List {
//
//                let currentPeriod = getCurrentPeriod()
//
//                ForEach(viewModel.periods, id: \.objectID) { period in
//
//
//
//                    Section("Actual Period") {
//                        if period.objectID == currentPeriod?.objectID {
//                            NavigationLink {
//                                PeriodDetailView(period: period)
//                            } label: {
//                                Text("\((period.startDate ?? Date())) - \(period.endDate ?? Date())")
//                            }
//                        }
//                    }
//
//                    Section("Other Periods") {
//                        if period.objectID != currentPeriod?.objectID {
//                            NavigationLink {
//                                PeriodDetailView(period: period)
//                            } label: {
//                                Text("\(period.startDate ?? Date()) - \(period.endDate ?? Date())")
//                            }
//                        }
//                    }
//
////                    NavigationLink {
////                        PeriodDetailView(period: period)
////                    } label: {
////                        Text("\(period.startDate ?? Date()) - \(period.endDate ?? Date())")
////                    }
//
//                }
//            }
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
