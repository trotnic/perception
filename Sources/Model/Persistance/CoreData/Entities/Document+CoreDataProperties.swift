//
//  CDDocument+CoreDataProperties.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//
//

import Foundation
import CoreData


extension CDDocument {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDocument> {
        return NSFetchRequest<CDDocument>(entityName: "CDDocument")
    }

    @NSManaged public var identifier: UUID?
    @NSManaged public var name: String?
    @NSManaged public var shelf: CDShelf?

}

extension CDDocument : Identifiable {

}
