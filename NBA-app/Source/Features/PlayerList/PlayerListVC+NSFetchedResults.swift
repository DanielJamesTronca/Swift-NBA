//
//  PlayerListVC+NSFetchedResultsControllerDelegate.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 28/05/21.
//

import Foundation
import UIKit
import CoreData

// MARK: - NSFetchedResultsControllerDelegate
extension PlayerListViewController: NSFetchedResultsControllerDelegate {
    // Configura diffable data soruce with snapshot
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
    ) {
        DispatchQueue.main.async {
            let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
            self.dataSource?.apply(snapshot, animatingDifferences: true)
            self.tableView.reloadData()
        }
    }
}
