//
//  DatabaseManageable.swift
//  Diffable_ds
//
//  Created by Nitanta Adhikari on 1/7/22.
//

import Foundation
import CoreData

protocol DatabaseManageable {
    static var database: CoreDataManager { get }
    static func findFirst<T: NSManagedObject>(predicate: NSPredicate?, type: T.Type) throws -> T?
}

extension DatabaseManageable {
    static var database: CoreDataManager {
        return CoreDataManager.shared
    }
    
    static func findFirst<T: NSManagedObject>(predicate: NSPredicate?, type: T.Type) -> T? {
        let request = T.fetchRequest()
        request.fetchLimit = 1
        request.predicate = predicate
        do {
            guard let data = try database.managedObjectContext.fetch(request).first else { return nil }
            return data as? T
        } catch {
            return nil
        }
    }
}
