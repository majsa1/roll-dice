//
//  Roll+CoreDataProperties.swift
//  RollDice
//
//  Created by Marjo Salo on 22/07/2021.
//
//

import Foundation
import CoreData


extension Roll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Roll> {
        return NSFetchRequest<Roll>(entityName: "Roll")
    }

    @NSManaged public var amountOfDice: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var result: Int16
    @NSManaged public var time: Date?
    @NSManaged public var die: Die?
    
    var formattedTime: TimeInterval {
        return time?.timeIntervalSince1970 ?? 0
    }

}

extension Roll : Identifiable {

}
