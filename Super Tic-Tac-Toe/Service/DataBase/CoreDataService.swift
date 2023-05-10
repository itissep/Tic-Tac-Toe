//
//  CoreDataService.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 04.05.2023.
//

import Foundation
import CoreData

protocol CoreDataManagerDescrption {
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]
    
    func create<T: NSManagedObject>(entityName: String, configurationBlock: @escaping (T?) -> Void, afterCreating completion: @escaping () -> Void)
    
    func delete<T: NSManagedObject>(request: NSFetchRequest<T>)
    
    func update<T: NSManagedObject>(reqeust: NSFetchRequest<T>, configurationBlock: @escaping (T?) -> Void)
    
    func initIfNeeded(successBlock: (() -> ())?, errorBlock: ((Error) -> ())?)
    
    var viewContext: NSManagedObjectContext { get }
}

final class CoreDataManager {
    
    static let shared: CoreDataManagerDescrption = CoreDataManager()
    
    private var isReady: Bool = false
    private let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "DataBase")
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

}

extension CoreDataManager: CoreDataManagerDescrption {
    func initIfNeeded(successBlock: (() -> ())?, errorBlock: ((Error) -> ())?) {
        guard !isReady else {
            successBlock?()
            return
        }
        
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                errorBlock?(error)
                return
            }
            
            self?.isReady = true
            successBlock?()
        }
    }
    
    func update<T>(reqeust: NSFetchRequest<T>, configurationBlock: @escaping (T?) -> Void) where T : NSManagedObject {
        
        let objects = fetch(request: reqeust)
        
        guard let object = objects.first else {
            return
        }
        
        viewContext.performAndWait {
            configurationBlock(object)
            try? viewContext.save()
        }
    }
    
    func delete<T>(request: NSFetchRequest<T>) where T : NSManagedObject {
        
        viewContext.perform { [weak self] in
            let objects = self?.fetch(request: request)
            
            objects?.forEach({ self?.viewContext.delete($0) })
            
            try? self?.viewContext.save()
        }
    }
    
    func create<T>(entityName: String, configurationBlock: @escaping (T?) -> Void, afterCreating completion: @escaping () -> Void) where T : NSManagedObject {
        
        container.performBackgroundTask({ backgroundContext in
            let object = NSEntityDescription.insertNewObject(forEntityName: entityName,
                                                             into: backgroundContext) as? T
            
            configurationBlock(object)
            
            try? backgroundContext.save()
            completion()
        })
    }
    
    func fetch<T>(request: NSFetchRequest<T>) -> [T] where T : NSManagedObject {
        return (try? viewContext.fetch(request)) ?? []
    }
}
