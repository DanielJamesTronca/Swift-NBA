//
//  PlayerListViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit
import CoreData

class PlayerListViewController: UITableViewController {
    
    var teamId: Int?
    var coreDataStack: CoreDataStack!
    
    var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>?
    
    lazy var fetchedResultsController: NSFetchedResultsController<PlayerCoreDataClass> = {
        let fetchRequest: NSFetchRequest<PlayerCoreDataClass> = PlayerCoreDataClass.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(PlayerCoreDataClass.playerId), ascending: true)
        
        if let teamId = self.teamId {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource = setupDataSource()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.performWithoutAnimation {
            do {
                try fetchedResultsController.performFetch()
            } catch let error as NSError {
                print("Fetching error: \(error), \(error.userInfo)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
}

// MARK: - NSFetchedResultsControllerDelegate
extension PlayerListViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
    ) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        dataSource?.apply(snapshot)
    }
}
