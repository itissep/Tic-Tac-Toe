//
//  GameAssembly.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 05.05.2023.
//

import UIKit

protocol GameAssemblyDescription {
    func createModule(with gameId: String) -> UIViewController
}

final class GameAssembly: GameAssemblyDescription {
    func createModule(with gameId: String)
    -> UIViewController {
        let viewModel = GameViewModel(gameId: gameId)
        let viewController = GameViewController(viewModel: viewModel)
        return viewController
    }
}
