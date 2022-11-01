//
//  CoreDataManager.swift
//  PersistentTodoList
//
//  Created by Alok Upadhyay on 30/03/2018.
//  Copyright © 2017 Alok Upadhyay. All rights reserved.


import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private let locationManager = LocationManager()

    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Challenges")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insert(users: [User]) {
        var tempUsers = [CDCUser]()
        for user in users {
            tempUsers.append(self.insert(user: user))
        }
    }
    
    func allUsers() -> [CDCUser] {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDCUser>(entityName: "CDCUser")
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func allChallenges() -> [CDChallenge] {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDChallenge>(entityName: "CDChallenge")
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func insert(user: User) -> CDCUser {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let newUser = CDCUser(context: managedContext)
        newUser.id = user.id
        newUser.email = user.email
        newUser.username = user.username
        for challenge in user.challenges {
            let challenges = CDChallenge(context: managedContext)
            challenges.id = challenge.id
            challenges.hint = challenge.hint
            challenges.photoImageName = challenge.photoImageName
            challenges.latitude = challenge.latitude
            challenges.longitude = challenge.longitude
            challenges.creatorID = challenge.creatorID
            challenges.distance = locationManager.getDistanceFrom(location: challenge.getLocation())
            
            for match in challenge.matches {
                let newMatch = CDMatch(context: managedContext)
                newMatch.id = match.id
                newMatch.latitude = match.latitude
                newMatch.longitude = match.longitude
                newMatch.verified = match.verified
                newMatch.user = match.creatorID
                challenges.addToMatches(newMatch)
            }
            
            for rate in challenge.ratings {
                let newRate = CDRating(context: managedContext)
                newRate.id = rate.id
                newRate.stars = Int16(rate.stars)
                newRate.creatorID = rate.creatorID
                challenges.addToRatings(newRate)
            }
            
            newUser.addToChallenge(challenges)
        }
        saveContext()
        return newUser
    }
        
    lazy var fetchedResultsController: NSFetchedResultsController<CDChallenge> = {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDChallenge>(entityName: "CDChallenge")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "distance", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController<CDChallenge>(fetchRequest: fetchRequest,
                                                                               managedObjectContext: managedContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
        print("1. NSFetchResultController Initialized :)")
        return fetchedResultsController
    }()
}

extension CoreDataManager {
    
    func getUsername(by creatorID: String?) -> String {
        allUsers().filter({ $0.id == (creatorID ?? "") }).first?.username ?? ""
    }
    
    func matches(createdBy userId: String) -> [CDMatch] {
        allChallenges()
            .flatMap { $0.allMatches }
            .filter { $0.creatorID == userId }
    }
    
    func ratings(createdBy userId: String) -> [CDRating] {
        allChallenges()
            .flatMap { $0.allRatings }
            .filter { $0.creatorID == userId }
    }
}
