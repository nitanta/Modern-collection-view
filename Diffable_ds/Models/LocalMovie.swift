//
//  Movies.swift
//  Diffable_ds
//
//  Created by Nitanta Adhikari on 1/7/22.
//

import Foundation
import CoreData


class LocalMovie: NSManagedObject, DatabaseManageable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<LocalMovie> {
        return NSFetchRequest<LocalMovie>(entityName: "LocalMovie")
    }

    @NSManaged var id: String
    @NSManaged var name: String?
    @NSManaged var key: String?
    
    static func saveMovies(_ id: String, name: String) -> LocalMovie {
        let localMovie: LocalMovie!
        if let movie = findFirst(predicate: NSPredicate(format: "id == %@", id), type: LocalMovie.self) {
            localMovie = movie
        } else {
            localMovie = LocalMovie(context: CoreDataManager.shared.managedObjectContext)
        }
        
        localMovie.id = id
        localMovie.name = name
        localMovie.key = String(name.first ?? "0")
        return localMovie
    }
    
    static func removeMovie(_ id: String) {
        if let movie = findFirst(predicate: NSPredicate(format: "id == %@", id), type: LocalMovie.self) {
            CoreDataManager.shared.managedObjectContext.delete(movie)
        }
    }
    
}
