//
//  OnboardingRepositoryImplementation.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation
import CoreData

class OnboardingRepositoryImpl: OnboardingRepository {
    
    func retrievePlayers(currentPage: Int, pageLimit: Int, _ completion: @escaping (Result<PlayersJSONResponse, Error>) -> Void) {
        let urlString: String = "https://free-nba.p.rapidapi.com/players?per_page=\(pageLimit)&page=\(currentPage)"
        RemoteDataSource.shared.execute(urlString, requestType: .get, completion: completion)
    }
    
    func save(coreDataStack: CoreDataStack, name: String, teamId: Int64, playerId: Int64, teamFullName: String, position: String) {
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
    
    func someEntityExists(coreDataStack: CoreDataStack, id: Int, fieldName: String) -> Bool {
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
    
    func getRecordsCount(coreDataStack: CoreDataStack) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerCoreDataClass")
        do {
            let count = try coreDataStack.managedContext.count(for: fetchRequest)
            return count
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
}

