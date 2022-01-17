//
//  CDShelf+CoreDataProperties.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//
//

import Foundation
import CoreData


extension CDShelf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDShelf> {
        return NSFetchRequest<CDShelf>(entityName: "CDShelf")
    }

    @NSManaged public var identifier: UUID?
    @NSManaged public var name: String?
    @NSManaged public var documents: NSSet?
    @NSManaged public var workspace: CDWorkspace?

}

// MARK: Generated accessors for documents
extension CDShelf {

    @objc(addDocumentsObject:)
    @NSManaged public func addToDocuments(_ value: CDDocument)

    @objc(removeDocumentsObject:)
    @NSManaged public func removeFromDocuments(_ value: CDDocument)

    @objc(addDocuments:)
    @NSManaged public func addToDocuments(_ values: NSSet)

    @objc(removeDocuments:)
    @NSManaged public func removeFromDocuments(_ values: NSSet)

}

extension CDShelf : Identifiable {

}
