//
//  CDRating+CoreDataProperties.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/31/22.
//
//

import Foundation
import CoreData


extension CDRating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRating> {
        return NSFetchRequest<CDRating>(entityName: "CDRating")
    }

    @NSManaged public var creatorID: String?
    @NSManaged public var id: String?
    @NSManaged public var stars: Int16
    @NSManaged public var challenges: CDChallenge?

}

extension CDRating : Identifiable {

}
