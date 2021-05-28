//
//  PlayerListViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit
import CoreData

class PlayerListViewController: UITableViewController {
    
    var teamData: TeamData?
    var coreDataStack: CoreDataStack!
    
    var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>?
    
    let searchController: UISearchController = UISearchController(
        searchResultsController: nil
    )
    
    // Delegate to handle transictions through detail view
    var detailsTransitioningDelegate: InteractiveModalTransitioningDelegate!
    
    lazy var fetchedResultsController: NSFetchedResultsController<PlayerCoreDataClass> = {
        let fetchRequest: NSFetchRequest<PlayerCoreDataClass> = PlayerCoreDataClass.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(PlayerCoreDataClass.completeName), ascending: true)
        
        if let teamId = self.teamData?.teamId {
            fetchRequest.predicate = NSPredicate(format: "teamId == %d", argumentArray: [teamId])
        }
        
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
    
    var filteredData: [PlayerCoreDataClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource = setupDataSource()
        self.tableView.tableFooterView = UIView()
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

extension PlayerListViewController {
    func setupDataSource() -> UITableViewDiffableDataSource<String, NSManagedObjectID> {
        UITableViewDiffableDataSource(tableView: tableView) { [unowned self] tableView, indexPath, _ in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerName", for: indexPath)
            let player = self.fetchedResultsController.object(at: indexPath)
            self.configure(cell: cell, for: player)
            return cell
        }
    }
    
    func configure(cell: UITableViewCell, for player: PlayerCoreDataClass) {
        cell.textLabel?.text = player.completeName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller: PlayerDetailViewController = PlayerDetailViewController(
            nibName: "PlayerDetailViewController",
            bundle: nil
        )
        detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        controller.playerData = self.fetchedResultsController.object(at: indexPath)
        present(
            controller,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension PlayerListViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
    ) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
