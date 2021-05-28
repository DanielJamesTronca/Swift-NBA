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
    
    var coreDataStack: CoreDataStack?
    
    // Beer repository to handle data
    private let onboardingRepository: OnboardingRepository
    // Beer repository initialization
    init(onboardingRepository: OnboardingRepository) {
        self.onboardingRepository = onboardingRepository
    }
    
    func retrieveAllPlayers(currentPage: Int, completionHandler: @escaping (PlayersJSONResponse?) -> Void) {
        self.onboardingRepository.retrievePlayers(currentPage: currentPage, pageLimit: self.pageLimit) { (response) in
            switch response {
            case .success(let players):
//                players.data.forEach { (player) in
//                    DispatchQueue.main.async {
//                        if !self.someEntityExists(id: player.id, fieldName: "playerId") {
//                            self.save(name: "\(player.firstName) \(player.lastName)", teamId: player.team.id, playerId: player.id, teamFullName: player.team.fullName)
//                        }
//                    }
//                }
                completionHandler(players)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
    }
    
//    func someEntityExists(id: Int, fieldName : String) -> Bool {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return false
//        }
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")
//
//        fetchRequest.predicate = NSPredicate(format: "\(fieldName) == %d", id)
//
//        var results: [NSManagedObject] = []
//
//        do {
//            results = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
//        }
//        catch {
//            print("error executing fetch request: \(error)")
//        }
//
//        return results.count > 0
//    }
    
    func save(name: String, teamId: Int, playerId: Int, teamFullName: String) {
        
        //        guard let coreDataStack = coreDataStack else {
        //            return
        //        }
        //
        //        let playerService: PlayerService = PlayerService(context: coreDataStack.managedContext)
        //        _ = playerService.createPlayer(name: name, teamId: teamId, playerId: playerId, teamFullName: teamFullName)
        //        coreDataStack.saveContext()
        
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let entity = NSEntityDescription.entity(forEntityName: "Player", in: managedContext)!
        let player = NSManagedObject(entity: entity, insertInto: managedContext)
        player.setValue(name, forKeyPath: "completeName")
        player.setValue(teamId, forKey: "teamId")
        player.setValue(playerId, forKey: "playerId")
        player.setValue(teamFullName, forKey: "teamFullName")
        do {
            try managedContext.save()
            //            self.player.append(player)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
