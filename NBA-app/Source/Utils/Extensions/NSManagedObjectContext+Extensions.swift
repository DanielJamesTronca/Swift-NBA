//
//  NSManagedObjectContext+Extensions.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 29/05/21.
//

import Foundation
import CoreData

// MARK: - Saving Contexts

/**
 Contextual information for handling Core Data context save errors.
 */
enum ContextSaveContextualInfo: String {
    case addPlayer = "adding a player"
}

extension NSManagedObjectContext {
    /**
     Save a context, or handle the save error (for example, when there data inconsistency or low memory).
     */
    func save(with contextualInfo: ContextSaveContextualInfo) {
        guard hasChanges else { return }
        do {
            try save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
