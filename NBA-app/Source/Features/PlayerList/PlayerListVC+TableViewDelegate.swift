//
//  PlayerListVC+TableViewDelegate.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 28/05/21.
//

import Foundation
import UIKit
import CoreData

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
        // Configure custom presenation for our view controller
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Set background color for cells.
        cell.backgroundColor = UIColor.nbaDark
    }
}
