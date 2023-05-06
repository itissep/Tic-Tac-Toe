//
//  GamesListViewModel.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 06.05.2023.
//

import Foundation

final class GamesListViewModel: NSObject {
    @Published var gamesCellModels: [GameCellModel] = []
    
    override init() {
        super.init()
        fetchGames()
    }
    
    private func fetchGames() {
        gamesCellModels = MockData.cells
    }
    
    func createNewGame() {
        
    }
    
    func deleteGame(at indexPath: IndexPath) {
        gamesCellModels.remove(at: indexPath.row)
    }
    
    func goToGame(with id: String) {
        
    }
}
