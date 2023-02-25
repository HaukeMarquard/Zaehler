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
    
    var icon: String
    var name: String
    
    @StateObject var viewModel: PeriodDetailViewModel = PeriodDetailViewModel()
    
    @FetchRequest var entries: FetchedResults<Entry>
    
    init(period: Period, icon: String, name: String) {
        self.period = period
        self.icon = icon
        self.name = name
        
        let predicate = NSPredicate(format: "period == %@", period)
        _entries = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], predicate: predicate)
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                Text(name)
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
            Text("Preis pro Monat anhand Tagesdurchschnitt: \(calculatePricePerMonth(), format: .currency(code: "EUR"))")
            
            // Entry List
            List {
                ForEach(entries) { entry in
                    VStack {
                        Text("\(entry.date.formatted(date: .abbreviated, time: .omitted))")
                        Text("\(String(format: "%.2f", entry.value)) \(period.unitType ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions(edge: .leading) {
                        NavigationLink {
                            EditEntryView(entry: entry, period: period)
                        } label: {
                            Text("Edit")
                        }
                        .tint(.orange)
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
            ToolbarItem(placement: .navigation) {
                Text(name)
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
    
    func calculatePricePerMonth() -> Double {
        
        let tagesVerbrauch = viewModel.daylyConsumption
        let tageZwischenDaten = daysBetweenDates()
        let monate = monthsBetweenDates()
        
        return (tagesVerbrauch * Double(tageZwischenDaten) * period.unitPrice) / Double(monate)
    }
    
    func monthsBetweenDates() -> Int {
        let months = calculateMonths()
        
        var count = 0
        for values in months.values {
            count += values.count
        }
        
        print("Count: \(count)")
        
        return count
    }
    
    func daysBetweenDates() -> Int {
        let startDate = period.startDate ?? Date()
        let endDate = period.endDate ?? Date()
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
        print("Tage: \(dateComponents.day)")
        return dateComponents.day ?? 0
    }

    
    func calculateMonths() -> [Int: [Int]] {
        let startDate = period.startDate ?? Date() // setzen Sie hier das Startdatum ein
        let endDate = period.endDate ?? Date() // setzen Sie hier das Enddatum ein

        var monthsDict = [Int: [Int]]()
        let calendar = Calendar.current

        let dateComponents = DateComponents(day: 1)
        var currentDate = calendar.date(from: calendar.dateComponents([.year, .month], from: startDate))!

        while currentDate <= endDate {
            let month = calendar.component(.month, from: currentDate)
            let year = calendar.component(.year, from: currentDate)
            
            if var months = monthsDict[year] {
                if !months.contains(month) {
                    months.append(month)
                    monthsDict[year] = months
                }
            } else {
                monthsDict[year] = [month]
            }
            
            currentDate = calendar.date(byAdding: dateComponents, to: currentDate)!
        }

//        for (year, months) in monthsDict {
//            print("\(year): \(months.map { String(format: "%02d", $0) }.joined(separator: ", "))")
//        }
        
        return monthsDict
    }
}

//struct PeriodDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeriodDetailView()
//    }
//}
