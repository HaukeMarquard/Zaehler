//
//  Period+CoreDataProperties.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//
//

import Foundation
import CoreData


extension Period {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Period> {
        return NSFetchRequest<Period>(entityName: "Period")
    }

    @NSManaged public var fixPrice: Double
    @NSManaged public var unitPrice: Double
    @NSManaged public var fixPriceInterval: String?
    @NSManaged public var unitType: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var startDate: Date?
    @NSManaged public var meter: Meter?

}

extension Period : Identifiable {

}
