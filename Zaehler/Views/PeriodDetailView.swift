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
    
    @State var showDetails: Bool = false
    @State var average: Double = 0.0
    
    @StateObject var viewModel: PeriodDetailViewModel = PeriodDetailViewModel()
    
    @FetchRequest var entries: FetchedResults<Entry>
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.managedObjectContext) private var viewContext

    
    let dateFormatter = DateFormatter()
    let dateFormatterChart = DateFormatter()
    let myDate = Date()
    let myLocalizedStringKey = "date_Format"
    let chartDateStringKey = "date_Format_Chart"
    
    let testDateFormatter = DateFormatter()
    
    
    init(period: Period, icon: String, name: String) {
        self.period = period
        self.icon = icon
        self.name = name
        
        let predicate = NSPredicate(format: "period == %@", period)
        _entries = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], predicate: predicate)
    }
    
    var body: some View {
        ScrollView {
            Text("\((period.startDate).formatted(date: .abbreviated, time: .omitted)) - \((period.endDate).formatted(date: .abbreviated, time: .omitted))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Chart
            ChartSection()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("totalConsumption")
                        .font(.callout)
                    Text("\(String(format: "%.2f", viewModel.wholeConsumption)) \(period.unitType)")
                        .font(.title3)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 120, maxHeight: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(UIColor.systemBackground).shadow(.drop(color: colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.8), radius: 2, x: 1, y: 1)))
                }
                
                .padding(.leading)
                .padding(.trailing, 4)
                
                VStack(alignment: .leading) {
                    Text("pricePerMonth")
                        .font(.callout)
                    Text("\(formatCurrency(calculatePricePerMonth()))")
                        .font(.title3)
                        .padding(.bottom)
                    Text(String(format: NSLocalizedString("totalPrice", comment: ""), formatCurrency(viewModel.wholePrice)))
                        .font(.footnote)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 120, maxHeight: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(UIColor.systemBackground).shadow(.drop(color: colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.8), radius: 2, x: 1, y: 1)))
                }
                
                .padding(.trailing)
                .padding(.leading, 4)
            }
            
            // Entry List
            HStack() {
                Text("entriesTitle")
                    .font(.subheadline)
                    .padding([.top, .leading])
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            List {
                ForEach(entries) { entry in
                    HStack {
                        Text("\(entry.date.formatted(date: .abbreviated, time: .omitted))")
                        Spacer()
                        Text("\(String(format: "%.2f", entry.value)) \(period.unitType)")
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
            .listRowSeparator(.hidden, edges: .all)
            .frame(minHeight: 200)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                infoButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                addButton()
            }
        }
        .onAppear {
            viewModel.setPeriod(period: period)
            dateFormatter.dateFormat = NSLocalizedString(myLocalizedStringKey, comment: "")
            dateFormatterChart.dateFormat = NSLocalizedString(chartDateStringKey, comment: "")
            testDateFormatter.dateFormat = "d.M"
        }
        .sheet(isPresented: $showDetails, onDismiss: {
            viewModel.calculateWholePrice()
        }, content: {
            EditPeriodView(period: period)
        })
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func ChartSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("dailyAverage")
                .foregroundColor(.secondary)
                .font(.footnote)
                .padding(.leading)

            Text("\(String(format: "%.2f", viewModel.daylyConsumption)) \(period.unitType)")
                .font(.title.bold())
                .padding(.leading)
            AnimatedChart()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                    .fill(.primary.shadow(.drop(radius: 2)))
                .fill(Color(UIColor.systemBackground).shadow(.drop(color: colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.8), radius: 2, x: 1, y: 1)))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.horizontal])
        .padding(.bottom, 8)
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        Chart {
            ForEach(entries.indices, id: \.self) { index in
                if index > 0 {
                    let showValue = calculateAverage(higherDate: entries[index].date, lowerDate: entries[index - 1].date, higherValue: entries[index].value, lowerValue: entries[index - 1].value)
                    let calendar = Calendar.current
                    let day = calendar.component(.day, from: entries[index].date)
                    let month = calendar.component(.month, from: entries[index].date)
                    LineMark(x: .value("Day", "\(day).\(month)"), y: .value("Value", showValue), series: .value("Year", "2023"))
                        .cornerRadius(10)
                        .interpolationMethod(.catmullRom)
                    AreaMark(x: .value("Day", "\(day).\(month)"), y: .value("Value", showValue), series: .value("Year", "2023"))
                        .cornerRadius(10)
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.accentColor.opacity(0.1).gradient)
//                    LineMark(x: .value("Day", entries[index].date.formatted(date: .numeric, time: .omitted)), y: .value("Value", showValue), series: .value("Year", "2023"))
//                        .cornerRadius(10)
//                        .interpolationMethod(.catmullRom)
//                    AreaMark(x: .value("Day", entries[index].date.formatted(date: .numeric, time: .omitted)), y: .value("Value", showValue), series: .value("Year", "2023"))
//                        .cornerRadius(10)
//                        .interpolationMethod(.catmullRom)
//                        .foregroundStyle(Color.accentColor.opacity(0.1).gradient)
                        
                }
            }
        }
        .foregroundColor(.primary)
    }
    
    @ViewBuilder
    func infoButton() -> some View {
        Button {
            showDetails = true
        } label : {
            Image(systemName: "info.circle")
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {

        NavigationLink {
            AddEntryView(period: period)
        } label: {
            Image(systemName: "plus.circle")
//                .font(.title3)
        }
        .padding([.vertical], 5)
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
        
        return count
    }
    
    func daysBetweenDates() -> Int {
        let startDate = period.startDate
        let endDate = period.endDate
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
        return dateComponents.day ?? 0
    }

    
    func calculateMonths() -> [Int: [Int]] {
        let startDate = period.startDate // setzen Sie hier das Startdatum ein
        let endDate = period.endDate // setzen Sie hier das Enddatum ein

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
//        PeriodDetailView(period: <#Period#>, icon: <#String#>, name: <#String#>)
//    }
//}

