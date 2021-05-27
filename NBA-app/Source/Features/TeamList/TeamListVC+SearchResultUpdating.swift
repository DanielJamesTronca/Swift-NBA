//
//  TeamListVC+SearchResultUpdating.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation
import UIKit

extension TeamListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    // Helper function to filter data
    func filterContentForSearchText(_ searchText: String) {
        self.viewModel.filteredTeams = self.viewModel.teamList.filter({ (team: TeamData) -> Bool in
            return team.teamFullName.lowercased().contains(searchText.lowercased())
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
