//
//  OnboardingViewModel.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation
import CoreData
import UIKit

class OnboardingViewModel {
    
    private var pageLimit: Int = 100
    
    private let coreDataStack: CoreDataStack
    
    // Beer repository to handle data
    private let onboardingRepository: OnboardingRepository
    // Beer repository initialization
    init(onboardingRepository: OnboardingRepository, coreDataStack: CoreDataStack) {
        self.onboardingRepository = onboardingRepository
        self.coreDataStack = coreDataStack
    }
    
    func retrieveAllPlayers(currentPage: Int, _ completionHandler: @escaping (Bool) -> Void) {
        self.onboardingRepository.retrievePlayers(currentPage: currentPage, pageLimit: self.pageLimit) { (response) in
            switch response {
            case .success(let players):
                players.data.forEach { (player) in
                    DispatchQueue.main.async {
                        if !self.someEntityExists(id: player.id, fieldName: "playerId") {
                            self.save(
                                name: "\(player.firstName) \(player.lastName)",
                                teamId: Int64(player.team.id),
                                playerId: Int64(player.id),
                                teamFullName: player.team.fullName,
                                position: player.position
                            )
                        }
                    }
                }
                completionHandler(true)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
    func save(name: String, teamId: Int64, playerId: Int64, teamFullName: String, position: String) {
        let playerService: PlayerService = PlayerService(context: coreDataStack.managedContext)
        _ = playerService.createPlayer(
            name: name,
            teamId: teamId,
            playerId: playerId,
            teamFullName: teamFullName,
            position: position
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
