//
//  PlayerProvider.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 29/05/21.
//

import Foundation
import CoreData

class TeamPlayerProvider {
    
    private(set) var persistentContainer: NSPersistentContainer
    private(set) var teamId: Int?
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    init(
        with persistentContainer: NSPersistentContainer,
        teamId: Int?,
        fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    ) {
        self.persistentContainer = persistentContainer
        self.teamId = teamId
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }
    
    // FetcResultController to perform core data actions
    lazy var fetchedResultsController: NSFetchedResultsController<PlayerCoreDataClass> = {
        let fetchRequest: NSFetchRequest<PlayerCoreDataClass> = PlayerCoreDataClass.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(PlayerCoreDataClass.completeName), ascending: true)
        
        // Filter by team id
        if let teamId = self.teamId {
            fetchRequest.predicate = NSPredicate(format: "teamId == %d", argumentArray: [teamId])
        }
        
        // Important!!
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = fetchedResultsControllerDelegate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        
        return fetchedResultsController
    }()
    
    // Add any additional operation here
    
    func addPlayer(
        in context: NSManagedObjectContext,
        name: String,
        teamId: Int64,
        playerId: Int64,
        teamFullName: String,
        position: String
    ) {
        context.perform {
            let player = PlayerCoreDataClass(context: context)
            player.completeName = name
            player.teamId = teamId
            player.playerId = playerId
            player.teamFullName = teamFullName
            player.position = position
            context.save(with: .addPlayer)
        }
    }
    
    func checkIfDataContainsPlayer(id: Int, fieldName: String) -> Bool {
        var results: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlayerCoreDataClass")
        fetchRequest.predicate = NSPredicate(format: "\(fieldName) == %d", id)
        do {
            results = try self.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    func getTotalPlayerCount() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerCoreDataClass")
        do {
            let count = try persistentContainer.viewContext.count(for: fetchRequest)
            return count
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
}
