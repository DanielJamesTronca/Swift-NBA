//
//  NSPersistenContainer+Extensions.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 29/05/21.
//

import Foundation
import CoreData
// MARK: - Creating Contexts

let appTransactionAuthorName = "NBA-app"

/**
 A convenience method for creating background contexts that specify the app as their transaction author.
 */
extension NSPersistentContainer {
    func backgroundContext() -> NSManagedObjectContext {
        let context = newBackgroundContext()
        context.transactionAuthor = appTransactionAuthorName
        return context
    }
}
