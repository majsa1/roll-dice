//
//  Die+CoreDataProperties.swift
//  RollDice
//
//  Created by Marjo Salo on 22/07/2021.
//
//

import Foundation
import CoreData


extension Die {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Die> {
        return NSFetchRequest<Die>(entityName: "Die")
    }

    @NSManaged public var amountOfSides: Int16
    @NSManaged public var rolls: NSSet?
    
    var formattedRolls: [Roll] {
        let set = rolls as? Set<Roll> ?? []
        return set.sorted {
            $0.formattedTime > $1.formattedTime
        }
    }
}

// MARK: Generated accessors for rolls
extension Die {

    @objc(addRollsObject:)
    @NSManaged public func addToRolls(_ value: Roll)

    @objc(removeRollsObject:)
    @NSManaged public func removeFromRolls(_ value: Roll)

    @objc(addRolls:)
    @NSManaged public func addToRolls(_ values: NSSet)

    @objc(removeRolls:)
    @NSManaged public func removeFromRolls(_ values: NSSet)

}

extension Die : Identifiable {

}
