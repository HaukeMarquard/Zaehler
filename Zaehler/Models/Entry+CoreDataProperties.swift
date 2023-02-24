//
//  Entry+CoreDataProperties.swift
//  Zaehler
//
//  Created by Hauke Marquard on 24.02.23.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var date: Date
    @NSManaged public var value: Double
    @NSManaged public var period: Period?

}

extension Entry : Identifiable {

}
