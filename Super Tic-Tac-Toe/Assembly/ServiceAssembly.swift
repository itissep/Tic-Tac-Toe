//
//  ServiceAssembly.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

protocol ServiceAssemblyDescription {
    var gameService: GameSavingServiceDescription { get }
    
}

final class ServiceAssembly: ServiceAssemblyDescription {
    lazy var coreDataService: CoreDataManagerDescrption = {
        CoreDataManager.shared
        }()
    
    lazy var gameService: GameSavingServiceDescription = {
        createGameService()
    }()
        
    private func createGameService() -> GameSavingServiceDescription {
        GameSavingService(coreDataService: coreDataService)
    }
}
