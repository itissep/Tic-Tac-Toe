//
//  GameAssembly.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 05.05.2023.
//

import UIKit

protocol GameAssemblyDescription {
    func createModule(with gameId: String, title: String) -> UIViewController
}

final class GameAssembly: GameAssemblyDescription {
    private let serviceAssembly: ServiceAssemblyDescription
    
    init(serviceAssembly: ServiceAssemblyDescription) {
        self.serviceAssembly = serviceAssembly
    }
    
    func createModule(with gameId: String, title: String)
    -> UIViewController {
        let gameService = serviceAssembly.gameService
        let viewModel = GameViewModel(gameId: gameId, gameService: gameService)
        let viewController = GameViewController(viewModel: viewModel, title: title)
        return viewController
    }
}
