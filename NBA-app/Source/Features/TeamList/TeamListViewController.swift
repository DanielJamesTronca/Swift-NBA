//
//  TeamListViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit

class TeamListViewController: UIViewController {

    let searchController: UISearchController = UISearchController(
        searchResultsController: nil
    )

    // Table view to display beer data
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // Table view refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh(_:)),
            for: UIControl.Event.valueChanged
        )
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    // MARK: - Generic var -
    
    // Detect if searchbar is empty
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Detect if we are filtering data
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var teamStatus: TeamStatusEnum = .loading
    
    var viewModel: TeamListViewModel = TeamListViewModel(teamRepository: TeamRepositoryImpl())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureTableView()
        self.setupConstraints()
        self.configureSearchController()
        // Current view title
        self.title = "nba_teams_title".localized
        self.view.backgroundColor = UIColor.nbaDark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.retrieveData()
    }
    
    fileprivate func retrieveData() {
        self.viewModel.retrieveAllTeams { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    // Something wrong! Show error from view model.
                    self.teamStatus = .ready
                    self.tableView.reloadData()
                    let alert = UIAlertController(
                        title: error.errorMessage,
                        message: "\(error.errorDescription), \(error.code)", // Fake error!!
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "generic_gotcha".localized, style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // If success => hide loader and relaod table view.
                    self.teamStatus = .ready
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Fake refresh here
        DispatchQueue.main.async {
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // Avoid multiple dividers if tableview is empty!
        tableView.tableFooterView = UIView()
        // Add refresh control
        tableView.addSubview(refreshControl)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.nbaDark
        // We can set custom row height because all of cell respect the same size.
        tableView.rowHeight = 85
        tableView.estimatedRowHeight = 85
        // Different cells type, so we can register them!
        let cells: [UITableViewCell.Type] = [
            EmptyTeamsTableViewCell.self,
            LoadingTeamsTableViewCell.self,
            TeamTableViewCell.self
        ]
        // Register cells through forEach
        cells.forEach {
            tableView.registerCell(type: $0)
        }
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search_teams_searchbar".localized
//        tableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.isTranslucent = true
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            // Table view constraints
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

}
