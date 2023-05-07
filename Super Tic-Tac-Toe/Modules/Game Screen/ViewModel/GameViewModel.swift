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
    
    @Published var cellModels: [Player?] = []
    
    private var eventPublisher: AnyPublisher<GameEvent, Never> = PassthroughSubject<GameEvent, Never>().eraseToAnyPublisher()
    private var subscriptions = Set<AnyCancellable>()
    
    private let gameId: String
    private var isOn: Bool = true
    private let boardManager: BoardManager
    
    
    init(gameId: String, gameService: GameSavingServiceDescription) {
        self.gameId = gameId
        self.boardManager = BoardManager(gameSavingService: gameService, gameId: gameId)
        super.init()
        
        setupBinding()
        boardManager.fetch(with: gameId)
    }
    
    func attachEventListener(with subject: AnyPublisher<GameEvent, Never>) {
        self.eventPublisher = subject
        eventPublisher
            .sink { [weak self] event in
                switch event {
                case .fetchGame:
                    #warning("TODO: figure out if needed")
                    break
                case .moveWasMade(at: let indexPath):
                    self?.moveWasMade(at: indexPath)
                }
            }
            .store(in: &subscriptions)
    }
    
    func setupBinding() {
        boardManager.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .gameFinishedWithDraw:
                    self?.isOn = false
                    print("DRAW")
                    #warning("TODO: draw view")
                    break
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
                case .gameFetched(let board, let player):
                    self?.configureCells(with: board)
                    self?.currentPlayer = player
                case .gameFinishedWithWinner(_, let direction):
                    print(direction)
                    self?.isOn = false
                    print("WIN")
                    #warning("TODO: winning view")
                    break
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
    
    private func gameWasEnded() {
        
    }
}
