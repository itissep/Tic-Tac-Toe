//
//  BaseCoordinator.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 05.05.2023.
//

import UIKit

protocol BaseCoordinatorDescription: Coordinator {
    func goToGame(with id: String)
}

class BaseCoordinator: NSObject, BaseCoordinatorDescription {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let gamesListAssembly: GamesListAssemblyDescription
    private let gameAssembly: GameAssemblyDescription
    
    init(navigationController: UINavigationController,
         gamesListAssembly: GamesListAssemblyDescription,
         gameAssembly: GameAssemblyDescription
    ) {
        self.gamesListAssembly = gamesListAssembly
        self.gameAssembly =  gameAssembly
        self.navigationController = navigationController
    }

    func start() {
        goToGamesList()
    }
    
    func goToGame(with id: String) {
        //
    }
    
    private func goToGamesList() {
        let viewController = gamesListAssembly.createModule()
        navigationController.pushViewController(viewController, animated: true)
    }
}