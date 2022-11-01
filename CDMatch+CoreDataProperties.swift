//
//  CDMatch+CoreDataProperties.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/31/22.
//
//

import Foundation
import CoreData


extension CDMatch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMatch> {
        return NSFetchRequest<CDMatch>(entityName: "CDMatch")
    }

    @NSManaged public var creatorID: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photoImageName: String?
    @NSManaged public var user: String?
    @NSManaged public var verified: Bool
    @NSManaged public var challenges: CDChallenge?

}

extension CDMatch : Identifiable {

}
