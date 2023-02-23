//
//  Meter+CoreDataProperties.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//
//

import Foundation
import CoreData


extension Meter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meter> {
        return NSFetchRequest<Meter>(entityName: "Meter")
    }

    @NSManaged public var icon: String?
    @NSManaged public var meterNumber: String?
    @NSManaged public var name: String?
    @NSManaged public var periods: NSSet?
    
    public var periodsArray: [Period] {
        let set = periods as? Set<Period> ?? []
        
        return set.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
    }

}

// MARK: Generated accessors for periods
extension Meter {

    @objc(addPeriodsObject:)
    @NSManaged public func addToPeriods(_ value: Period)

    @objc(removePeriodsObject:)
    @NSManaged public func removeFromPeriods(_ value: Period)

    @objc(addPeriods:)
    @NSManaged public func addToPeriods(_ values: NSSet)

    @objc(removePeriods:)
    @NSManaged public func removeFromPeriods(_ values: NSSet)

}

extension Meter : Identifiable {

}
