//
//  PeriodDetailView.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//

import SwiftUI
import Charts

struct PeriodDetailView: View {
    
    var period: Period
    
    @StateObject var viewModel: PeriodDetailViewModel = PeriodDetailViewModel()
    
    @FetchRequest var entries: FetchedResults<Entry>
    
    init(period: Period) {
        self.period = period
        
        let predicate = NSPredicate(format: "period == %@", period)
        _entries = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], predicate: predicate)
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "circle")
                Text("Meter Title")
            }
            .font(.title)
            Text("\((period.startDate ?? Date()).formatted(date: .abbreviated, time: .omitted)) - \((period.endDate ?? Date()).formatted(date: .abbreviated, time: .omitted))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Chart
            Chart {
                ForEach(entries.indices, id: \.self) { index in
                    if index > 0 {
                        let showValue = calculateAverage(higherDate: entries[index].date, lowerDate: entries[index - 1].date, higherValue: entries[index].value, lowerValue: entries[index - 1].value)

                        LineMark(x: .value("Day", entries[index].date.formatted(date: .abbreviated, time: .omitted)), y: .value("Value", showValue), series: .value("Year", "2023"))
                            .cornerRadius(10)
                            .interpolationMethod(.catmullRom)
                    } else {
                        LineMark(x: .value("Day", entries[index].date.formatted(date: .abbreviated, time: .omitted)), y: .value("Value", 0), series: .value("Year", "2023"))
                            .cornerRadius(10)
                            .interpolationMethod(.catmullRom)
                    }
                }
            }
            
            Text("Gesamtverbrauch: \(String(format: "%.2f", viewModel.wholeConsumption)) \(period.unitType ?? "")")
            Text("Tagesdurchschnitt: \(String(format: "%.2f", viewModel.daylyConsumption)) \(period.unitType ?? "")")
            Text("Gesamtpreis: \(viewModel.wholePrice, format: .currency(code: "EUR"))")
            
            // Entry List
            List {
                ForEach(entries) { entry in
                    VStack {
                        Text("\(entry.date.formatted(date: .abbreviated, time: .omitted))")
                        Text("\(String(format: "%.2f", entry.value)) \(period.unitType ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete { indexSet in
                    viewModel.deleteEntry(index: indexSet)
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
            AddEntryView(period: period)
        } label: {
            Image(systemName: "plus.circle")
                .font(.title3)
        }
        .padding([.vertical, .leading], 5)
    }
    
    func calculateAverage(higherDate: Date, lowerDate: Date, higherValue: Double, lowerValue: Double) -> Double {
        let difference = higherValue - lowerValue
//        var dayDiff = (higherDate - lowerDate) / 60 / 60 / 24
        var dayDiff = (higherDate - lowerDate).day
        if (dayDiff! < 1) {
            dayDiff = 1
        }
        return difference / Double(dayDiff!)
    }
}

//struct PeriodDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeriodDetailView()
//    }
//}
