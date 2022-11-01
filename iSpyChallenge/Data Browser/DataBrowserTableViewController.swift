//
//  DataBrowserTableViewController.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class DataBrowserTableViewController: UITableViewController {
    var dataController: DataController?
    
    private var users: [User] = []
    private let placeholder = UIImage(named: "placeholder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        registerForDataControllerNotifications()
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        if let user = users[safe: indexPath.row] {
            cell.textLabel?.text = user.username
            cell.detailTextLabel?.text = user.email
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.image = placeholder
            user.avatarLargeURL?.loadedIntoImage(closure: { image in
                cell.imageView?.image = image
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowUser", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        injectProperties(viewController: segue.destination)
    }
    
    // MARK: - Injection
    
    private func injectProperties(viewController: UIViewController) {
        if let vc = viewController as? UserTableViewController {
            vc.dataController = dataController
            vc.userId = users[safe: tableView.indexPathForSelectedRow?.row]?.id
        }
    }
    
    // MARK: Updating UI
    
    private func registerForDataControllerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .dataControllerDidUpdate, object: dataController)
    }
    
    @objc private func updateUI() {
        users = dataController?.allUsers ?? []
        tableView.reloadData()
    }
}
