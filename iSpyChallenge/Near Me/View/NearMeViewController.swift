//
//  NearMeViewController.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/28/22.
//

import UIKit
import CoreData

class NearMeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataController: DataController?
    private let sharedDataManager = CoreDataManager.sharedManager
    func fetchAllChallenges() {
        sharedDataManager.fetchedResultsController.delegate = self
        do {
            print("2. NSFetchResultController will start fetching")
            try sharedDataManager.fetchedResultsController.performFetch()
            print("3. NSFetchResultController did end fetching")
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllChallenges()
        tableView.backgroundColor = UIColor(named: "tableBg")
    }
}


extension NearMeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let sections = sharedDataManager.fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NearMeContentCell
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    func configureCell(_ cell: NearMeContentCell, at indexPath: IndexPath) {
        let challenge = sharedDataManager.fetchedResultsController.object(at: indexPath)
        cell.contentText.text = challenge.hint
        cell.nameLabel.text = "By: \(sharedDataManager.getUsername(by: challenge.creatorID))"
        
        let verifiedMatches = challenge.allMatches.filter({ $0.verified == true })
        cell.winnerLabel.text = "\(verifiedMatches.count) wins"
        let ratings = challenge.allRatings
        let selectedUserRatingValue = Double(ratings.reduce(0) { $0 + $1.stars }) / Double(ratings.count)
        
        cell.ratingLabel.text = String(format: "%0.2f stars", selectedUserRatingValue.isNaN ? 0 : selectedUserRatingValue)
        cell.distanceLabel.text = String(format: "%0.2fm", challenge.distance)
        cell.backgroundColor = UIColor(named: "tableBg")
        cell.cellContentView.layer.cornerRadius = 5.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        injectProperties(viewController: segue.destination)
    }
    
    private func injectProperties(viewController: UIViewController) {
        if let vc = viewController as? NearMeDetailController {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            let challenge = sharedDataManager.fetchedResultsController.object(at: selectedIndexPath)
            vc.challenge = challenge
        }
    }
}

extension NearMeViewController  : NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        print("B. NSFetchResultController didChange NSFetchedResultsChangeType \(type.rawValue):)")
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath,
                let cell = tableView.cellForRow(at: indexPath) as? NearMeContentCell {
                configureCell(cell, at: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        @unknown default:
            fatalError()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("A. NSFetchResultController controllerWillChangeContent :)")
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
