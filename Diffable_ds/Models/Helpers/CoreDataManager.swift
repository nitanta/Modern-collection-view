//
//  CoredataManager.swift
//  Diffable_ds
//
//  Created by Nitanta Adhikari on 1/7/22.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diffable_ds")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteData() {
        let manager = CoreDataManager.shared
        manager.clearEntities(entities: [
            String(describing: LocalMovie.self),
        ])
    }
    
    
    private func clearEntities(entities: [String]) {
        let context = CoreDataManager.shared.managedObjectContext
        context.perform {
            do {
                try entities.forEach { (entityName) in
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
                    let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    try context.execute(request)
                }
                try context.save()
            } catch {
                assertionFailure("Cannot perform delete \(error)")
            }
        }
    }
}
