//
//  Period+CoreDataProperties.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//
//

import Foundation
import CoreData


extension Period {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Period> {
        return NSFetchRequest<Period>(entityName: "Period")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var fixPrice: Double
    @NSManaged public var fixPriceInterval: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var unitPrice: Double
    @NSManaged public var unitType: String?
    @NSManaged public var meter: Meter?
    @NSManaged public var entries: NSSet?
    
    public var entriesArray: [Entry] {
        let set = entries as? Set<Entry> ?? []
        
        return set.sorted { $0.date ?? Date() < $1.date ?? Date() }
    }

}

// MARK: Generated accessors for entries
extension Period {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension Period : Identifiable {

}
