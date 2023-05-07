//
//  GameViewModel.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 06.05.2023.
//

import Foundation
import Combine

final class GameViewModel: NSObject {
    @Published var gameTitle: String?
    @Published var movesNumber: Int?
    @Published var board: [[Player]]?
    @Published var currentPlayer: Player?
    
    private var eventPublisher: AnyPublisher<GameEvent, Never> = PassthroughSubject<GameEvent, Never>().eraseToAnyPublisher()
    private var subscriptions = Set<AnyCancellable>()
    
    private let gameId: String
    
    init(gameId: String) {
        self.gameId = gameId
        super.init()
    }
    
    func attachEventListener(with subject: AnyPublisher<GameEvent, Never>) {
        self.eventPublisher = subject
        eventPublisher
            .sink { [weak self] event in
                switch event {
                case .fetchGame:
                    self?.fetchGame()
                case .moveWasMade(at: let indexPath):
                    self?.moveWasMade(at: indexPath)
                }
            }
            .store(in: &subscriptions)
    }

    private func moveWasMade(at indexPath: IndexPath) {
        
    }
    
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
