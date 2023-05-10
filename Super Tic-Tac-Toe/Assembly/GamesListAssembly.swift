//
//  GamesListAssembly.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 05.05.2023.
//

import UIKit

protocol GamesListAssemblyDescription {
    func createModule(with coordinator: BaseCoordinatorDescription) -> UIViewController
}

final class GamesListAssembly: GamesListAssemblyDescription {
    private let serviceAssembly: ServiceAssemblyDescription
    
    init(serviceAssembly: ServiceAssemblyDescription) {
        self.serviceAssembly = serviceAssembly
    }
    
    func createModule(with coordinator: BaseCoordinatorDescription) -> UIViewController {
        let gameSavingService = serviceAssembly.gameService
        let viewModel = GamesListViewModel(coordinator: coordinator, gameService: gameSavingService)
        let viewController = GamesListViewController(viewModel: viewModel)
        return viewController
    }
}
