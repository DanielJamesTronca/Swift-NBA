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
}
