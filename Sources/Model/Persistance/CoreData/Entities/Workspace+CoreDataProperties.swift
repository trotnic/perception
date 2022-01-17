//
//  Workspace+CoreDataProperties.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//
//

import Foundation
import CoreData


extension CDWorkspace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWorkspace> {
        return NSFetchRequest<CDWorkspace>(entityName: "CDWorkspace")
    }

    @NSManaged public var identifier: UUID?
    @NSManaged public var name: String?
    @NSManaged public var shelfs: NSSet?

}

// MARK: Generated accessors for shelfs
extension CDWorkspace {

    @objc(addShelfsObject:)
    @NSManaged public func addToShelfs(_ value: CDShelf)

    @objc(removeShelfsObject:)
    @NSManaged public func removeFromShelfs(_ value: CDShelf)

    @objc(addShelfs:)
    @NSManaged public func addToShelfs(_ values: NSSet)

    @objc(removeShelfs:)
    @NSManaged public func removeFromShelfs(_ values: NSSet)

}

extension CDWorkspace : Identifiable {

}
