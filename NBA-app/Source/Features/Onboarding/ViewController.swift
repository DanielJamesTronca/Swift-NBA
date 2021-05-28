//
//  ViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var viewModel: OnboardingViewModel = OnboardingViewModel(onboardingRepository: OnboardingRepositoryImpl())
    
    let coreDataStack: CoreDataStack = {
        //swiftlint:disable:next force_cast
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        return coreDataStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.getRecordsCount() <= 3300 {
            self.retrieveBigBatchOfPlayers()
        } else {
            setRootViewController()
        }
    }
    
    private func retrieveBigBatchOfPlayers() {
        let dispatchGroup: DispatchGroup = DispatchGroup()
        for i in 1 ..< 35 {
            dispatchGroup.enter()
            self.viewModel.retrieveAllPlayers(currentPage: i) { (players) in
                if let players = players {
                    players.data.forEach { (player) in
                        DispatchQueue.main.async {
                            if !self.someEntityExists(id: player.id, fieldName: "playerId") {
                                self.save(
                                    name: "\(player.firstName) \(player.lastName)",
                                    teamId: Int64(player.team.id),
                                    playerId: Int64(player.id),
                                    teamFullName: player.team.fullName
                                )
                            }
                        }
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Finished all requests!")
            self.setRootViewController()
        }
    }
    
    func getRecordsCount() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerCoreDataClass")
        do {
            let count = try coreDataStack.managedContext.count(for: fetchRequest)
            return count
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    fileprivate func setRootViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "TeamList", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TeamListViewController") as! TeamListViewController
        newViewController.coreDataStack = self.coreDataStack
        let navi =  UINavigationController.init(rootViewController: newViewController)
        UIApplication.shared.windows.first?.rootViewController = navi
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func save(name: String, teamId: Int64, playerId: Int64, teamFullName: String) {
        let playerService: PlayerService = PlayerService(context: coreDataStack.managedContext)
        _ = playerService.createPlayer(
            name: name,
            teamId: teamId,
            playerId: playerId,
            teamFullName: teamFullName
        )
        coreDataStack.saveContext()
    }
    
    func someEntityExists(id: Int, fieldName : String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlayerCoreDataClass")
        fetchRequest.predicate = NSPredicate(format: "\(fieldName) == %d", id)
        var results: [NSManagedObject] = []
        do {
            results = try coreDataStack.managedContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
}
