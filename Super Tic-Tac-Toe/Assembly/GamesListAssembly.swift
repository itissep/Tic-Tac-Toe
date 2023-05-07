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
    func createModule(with coordinator: BaseCoordinatorDescription) -> UIViewController {
        let viewModel = GamesListViewModel(coordinator: coordinator)
        let viewController = GamesListViewController(viewModel: viewModel)
        return viewController
    }
}
