//
//  ServiceAssembly.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

protocol ServiceAssemblyDescription {
//    var coreDataService: CoreDataServiceDescrption { get }
    var gameService: GameSavingServiceDescription { get }
    
}

final class ServiceAssembly: ServiceAssemblyDescription {
//    lazy var coreDataService: CoreDataServiceDescrption = {
//            CoreDataService()
//        }()
//
    #warning("TODO: add core data dependency")
    lazy var gameService: GameSavingServiceDescription = {
        createGameService()
    }()
        
    private func createGameService() -> GameSavingServiceDescription {
        GameSavingService()
    }
}
