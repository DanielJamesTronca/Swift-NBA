//
//  PlayerListViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit
import CoreData

typealias DataSource = UITableViewDiffableDataSource<String, NSManagedObjectID>

class PlayerListViewController: UITableViewController {
    
    // Team data from previous view controller
    var teamData: TeamData?
    
    // UITablew view diffable data source with CoreData
    var dataSource: DataSource?
    
    // Delegate to handle transictions through detail view
    var detailsTransitioningDelegate: InteractiveModalTransitioningDelegate!
    
    // Data provider
    lazy var dataProvider: TeamPlayerProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = TeamPlayerProvider(
            with: appDelegate!.coreDataStack.storeContainer,
            teamId: teamData?.teamId,
            fetchedResultsControllerDelegate: self
        )
        return provider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource = setupDataSource()
        // Current view configuration
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.nbaDark
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.retrieveData { (success) in
            if success,
               let teamAbbreviation = self.teamData?.teamAbbreviation,
               let playerCount = self.dataProvider.fetchedResultsController.fetchedObjects?.count {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.title = "\(teamAbbreviation) (\(playerCount))"
                }
            }
        }
    }
    
    fileprivate func retrieveData(completionHandler: @escaping (_ success: Bool) -> Void) {
        UIView.performWithoutAnimation {
            do {
                try dataProvider.fetchedResultsController.performFetch()
                completionHandler(true)
            } catch let error as NSError {
                completionHandler(false)
                print("Fetching error: \(error), \(error.userInfo)")
            }
        }
    }
}
