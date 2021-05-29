//
//  PlayerListViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit
import CoreData

class PlayerListViewController: UITableViewController {
    
    // Team data from previous view controller
    var teamData: TeamData?
    
    // Core data stack to perform Core Data actions
    var coreDataStack: CoreDataStack!
    
    // UITablew view diffable data source with CoreData
    var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>?
    
    // Delegate to handle transictions through detail view
    var detailsTransitioningDelegate: InteractiveModalTransitioningDelegate!
    
    // FetcResultController to perform core data actions
    lazy var fetchedResultsController: NSFetchedResultsController<PlayerCoreDataClass> = {
        let fetchRequest: NSFetchRequest<PlayerCoreDataClass> = PlayerCoreDataClass.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(PlayerCoreDataClass.completeName), ascending: true)
        
        // Filter by team id
        if let teamId = self.teamData?.teamId {
            fetchRequest.predicate = NSPredicate(format: "teamId == %d", argumentArray: [teamId])
        }
        
        // Important!!
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.retrieveData { (success) in
            if success,
               let teamAbbreviation = self.teamData?.teamAbbreviation,
               let playerCount = self.fetchedResultsController.fetchedObjects?.count {
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
                try fetchedResultsController.performFetch()
                completionHandler(true)
            } catch let error as NSError {
                completionHandler(false)
                print("Fetching error: \(error), \(error.userInfo)")
            }
        }
    }
}
