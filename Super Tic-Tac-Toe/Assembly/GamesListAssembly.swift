//
//  GamesListAssembly.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 05.05.2023.
//

import UIKit

protocol GamesListAssemblyDescription {
    func createModule() -> UIViewController
}

final class GamesListAssembly: GamesListAssemblyDescription {
    func createModule() -> UIViewController {
        let viewModel = GamesListViewModel()
        let viewController = GamesListViewControllerr(viewModel: viewModel)
        return viewController
    }
}
