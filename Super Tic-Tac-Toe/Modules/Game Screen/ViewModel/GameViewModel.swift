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
    @Published var board: [[Player?]]?
    @Published var currentPlayer: Player?
    @Published var gameResult: GameResult?
    
    @Published var cellModels: [Player?] = []
    
    private var eventPublisher: AnyPublisher<IndexPath, Never> = PassthroughSubject<IndexPath, Never>().eraseToAnyPublisher()
    private var subscriptions = Set<AnyCancellable>()
    
    private let gameId: String
    private var isOn: Bool = true
    private let boardManager: GameManager
    
    
    init(gameId: String, gameService: GameSavingServiceDescription) {
        self.gameId = gameId
        self.boardManager = GameManager(gameSavingService: gameService, gameId: gameId)
        super.init()
        
        setupBinding()
        boardManager.fetch(with: gameId)
    }
    
    func attachEventListener(with subject: AnyPublisher<IndexPath, Never>) {
        self.eventPublisher = subject
        eventPublisher
            .sink { [weak self] indexPath in
                self?.moveWasMade(at: indexPath)
            }
            .store(in: &subscriptions)
    }
    
    func setupBinding() {
        boardManager.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .updateWith(let newBoard):
                    self?.configureCells(with: newBoard)
                case .newGame(let title, let board):
                    self?.gameTitle = title
                    self?.configureCells(with: board)
                    self?.currentPlayer = .X
                case .error:
                    break
                case .placeIsTaken:
                    break
                case .gameFetched(let board, let player, let title):
                    self?.configureCells(with: board)
                    self?.gameTitle = title
                    self?.currentPlayer = player
                case .gameFinished(let result):
                    self?.isOn = false
                    self?.gameResult = result
                case .changePlayer:
                    self?.currentPlayer = self?.currentPlayer?.enemy()
                }
            }
            .store(in: &subscriptions)
    }

    private func moveWasMade(at indexPath: IndexPath) {
        guard isOn else { return }
        guard let currentPlayer else { return }
        boardManager.moveWasMade(player: currentPlayer, indexPath: indexPath)
    }
    
    private func configureCells(with board: [[Player?]]) {
        var cells: [Player?] = []
        for y in 0...2 {
            for x in 0...2 {
                cells.append(board[x][y])
            }
        }
        cellModels = cells
    }
}
