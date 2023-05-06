//
//  CoreDataService.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 04.05.2023.
//

import Foundation
import CoreData

protocol CoreDataServiceDescrption {
    func fetch<T: NSManagedObject>(fromBackground: Bool, request: NSFetchRequest<T>) -> [T]
    
    func create<T: NSManagedObject>(entityName: String, configurationBlock: @escaping (T?) -> Void)
    func delete<T: NSManagedObject>(_ object: T)
    func update<T: NSManagedObject>(_ object: T, configurationBlock: @escaping (T?) -> Void)
    
    func initIfNeeded(successBlock: (() -> Void)?, errorBlock: ((Error) -> Void)?)
    
    var viewContext: NSManagedObjectContext { get }
}
