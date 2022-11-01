//
//  CDCUser+CoreDataProperties.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/31/22.
//
//

import Foundation
import CoreData


extension CDCUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCUser> {
        return NSFetchRequest<CDCUser>(entityName: "CDCUser")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var username: String?
    @NSManaged public var challenge: NSSet?
    
    var challenges: [CDChallenge] {
        return challenge?.allObjects as? [CDChallenge] ?? []
    }
}

// MARK: Generated accessors for challenge
extension CDCUser {

    @objc(addChallengeObject:)
    @NSManaged public func addToChallenge(_ value: CDChallenge)

    @objc(removeChallengeObject:)
    @NSManaged public func removeFromChallenge(_ value: CDChallenge)

    @objc(addChallenge:)
    @NSManaged public func addToChallenge(_ values: NSSet)

    @objc(removeChallenge:)
    @NSManaged public func removeFromChallenge(_ values: NSSet)

}

extension CDCUser : Identifiable {

}
