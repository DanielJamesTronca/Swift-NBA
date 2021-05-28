//
//  TeamListVC+TableViewDelegate.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation
import UIKit
import CoreData

extension TeamListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch teamStatus {
        case .loading:
            return 1
        case .ready:
            if isFiltering {
                // If we are in "isFiltering" status, we return filtered list
                if self.viewModel.filteredTeams.isEmpty {
                    return 1
                } else {
                    return self.viewModel.filteredTeams.count
                }
            } else {
                // Otherwise return beerlist
                if self.viewModel.teamList.isEmpty {
                    return 1
                } else {
                    return self.viewModel.teamList.count
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Number of section
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let teamList: [TeamData] = isFiltering ? self.viewModel.filteredTeams : self.viewModel.teamList
        
        switch teamStatus {
        case .loading:
            // If data is loading we return LoadingTableViewCell
            guard let cell = tableView.dequeueCell(withType: LoadingTeamsTableViewCell.self, for: indexPath) as? LoadingTeamsTableViewCell else {
                return UITableViewCell()
            }
            
            // Remove programmatically dividers only if isLoading
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.activityIndicator.startAnimating()
            cell.selectionStyle = .none
            return cell
        case .ready:
            if teamList.isEmpty {
                // If data is empty we return EmptyTeamsTableViewCell
                guard let cell = tableView.dequeueCell(withType: EmptyTeamsTableViewCell.self, for: indexPath) as? EmptyTeamsTableViewCell else {
                    return UITableViewCell()
                }
                
                // Remove programmatically dividers only if isLoading
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueCell(withType: TeamTableViewCell.self, for: indexPath) as? TeamTableViewCell else {
                    return UITableViewCell()
                }
                // Remove selection style
                cell.selectionStyle = .none
                cell.configure(with: teamList[indexPath.row])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Team list
        let teamList: [TeamData] = isFiltering ? self.viewModel.filteredTeams : self.viewModel.teamList
        switch teamStatus {
        case .ready:
            print("Cell tapped")
            guard let vc = UIStoryboard(name: "PlayerList", bundle: nil).instantiateViewController(identifier: "PlayerListViewController") as? PlayerListViewController else {
                return
            }
            let teamId: Int = teamList[indexPath.row].teamId
//            vc.playerList = self.viewModel.retrievePlayers(teamId: teamId)
            vc.coreDataStack = self.coreDataStack
            vc.teamId = teamId
            self.navigationController?.pushViewController(vc, animated: true)
        case .loading:
            print("Loader tapped")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Set background color for cells.
        cell.backgroundColor = UIColor.nbaDark
    }
}
