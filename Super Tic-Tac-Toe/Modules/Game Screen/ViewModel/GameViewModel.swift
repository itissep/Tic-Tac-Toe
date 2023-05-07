//
//  GameViewModel.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 06.05.2023.
//

import Foundation

final class GameViewModel: NSObject {
    @Published var gameTitle: String?
    @Published var movesNumber: Int?
    @Published var board: [[Player]]?
    @Published var currentPlayer: Player?
    
    private let gameId: String
    
    init(gameId: String) {
        self.gameId = gameId
        super.init()
        
        fetchGame()
    }

    func moveWasMade(at indexPath: IndexPath, by player: Player) {
        
    }
    
    #warning("TODO: add listeners")
    
    private func fetchGame() {
        let game = MockData.game
        gameTitle = game.title
        movesNumber = game.numberOfMoves
        currentPlayer = game.currentPlayer
        board = game.board
    }
    
    private func gameWasEnded() {
        
    }
}
