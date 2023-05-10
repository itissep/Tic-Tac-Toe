//
//  BoardManager.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation
import Combine

protocol GameManagerDescription {
    var eventPublisher: AnyPublisher<BoardEvent, Never> { get }
    
    func fetch()
    func moveWasMade(player: Player, indexPath: IndexPath)
}

final class GameManager: GameManagerDescription {
    private var board: [[Player?]]?
    private var lastMove: Move?
    private var emptyPlaces: Int = 9
    
    var eventPublisher: AnyPublisher<BoardEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    private let eventSubject = PassthroughSubject<BoardEvent, Never>()
    
    private let id: String
    private let gameSavingService: GameSavingServiceDescription
    
    init(gameSavingService: GameSavingServiceDescription) {
        self.gameSavingService = gameSavingService
        
        var boardItems: [[Player?]] = []
        for x in 0...2 {
            for y in 0...2 {
                boardItems[x][y] = nil
            }
        }
        self.board = boardItems
        self.id = ""
    }
    
    init(gameSavingService: GameSavingServiceDescription, gameId: String) {
        self.gameSavingService = gameSavingService
        self.id = gameId
        
    }
    
    func fetch() {
        DispatchQueue.global().async {[weak self] in
            guard let self else { return }
            self.gameSavingService.fetchGame(withId: self.id) { result in
                switch result {
                case .failure(_):
                    break
                case .success(let gameModel):
                    self.configureGame(with: gameModel)
                }
            }
        }
    }
    
    func moveWasMade(player: Player, indexPath: IndexPath) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let newMove = Move(location: self.location(for: indexPath), player: player)
            guard self.isEmpty(at: newMove.location) else { return }
            self.placeMove(newMove)
            self.checkForCompletion()
        }
    }
    
    private func configureGame(with gameModel: GameModel) {
        board = gameModel.board
        lastMove = gameModel.lastMove
        getEmptyPlaces()
        
        let currentPlayer = gameModel.lastMove?.player ?? .X
        eventSubject.send(.gameFetched(gameModel.board, currentPlayer, gameModel.title))
        checkForCompletion()
    }
    
    private func isEmpty(at location: (x: Int, y: Int)) -> Bool {
        guard let board else { return true }
        return board[location.x][location.y] == nil
    }
    
    private func location(for indexPath: IndexPath) -> (x:Int, y:Int) {
        let row = indexPath.row
        let x = row % 3
        let y = Int(row/3)
        return (x, y)
    }
    
    private func placeMove(_ move: Move) {
        lastMove = move
        guard let lastMove else { return }
        emptyPlaces -= 1
        board?[lastMove.location.x][lastMove.location.y] = lastMove.player
        guard let board else { return }
        gameSavingService.updateAfterMove(
            withId: id,
            move: lastMove,
            board: board
        ) {[weak self] result in
            switch result {
            case .success(_):
                self?.eventSubject.send(.updateWith(board))
            case .failure(_):
                self?.eventSubject.send(.error)
            }
        }
    }
    
    private func getEmptyPlaces(){
        guard let board else { return }
        var count = 0
        for x in 0...2 {
            for y in 0...2 {
                if board[x][y] == nil { count += 1}
            }
        }
        emptyPlaces = count
    }
    
    private func checkForCompletion() {
        checkBoard {[weak self] winningDerection in
            let result: BoardEvent
            if let winningDerection {
                result = .gameFinished(winningDerection)
            } else if self?.emptyPlaces == 0 {
                result = .gameFinished(.draw)
            } else {
                result = .changePlayer
            }
            
            self?.eventSubject.send(result)
        }
    }
    
    private func checkBoard(_ completion: @escaping (GameResult?) -> Void) {
            let results = [
                checkColumn(),
                checkRow(),
                checkDiagonals()
            ]
            completion(results.first(where:{ $0 != nil }) ?? nil)
    }
    
    private func checkColumn() -> GameResult? {
        guard let lastMove, let board else { return nil }
        let player = lastMove.player
        let x = lastMove.location.x
        if
            board[x][0] == player &&
                board[x][1] == player &&
                board[x][2] == player
        {
            return .column(x)
        } else {
            return nil
        }
    }
    
    private func checkRow() -> GameResult? {
        guard let lastMove, let board else { return nil }
        let player = lastMove.player
        let y = lastMove.location.y
        if
            board[0][y] == player &&
                board[1][y] == player &&
                board[2][y] == player
        {
            return .row(y)
        } else {
            return nil
        }
    }
    
    private func checkDiagonals() -> GameResult? {
        guard let lastMove, let board else { return nil }
        let player = lastMove.player
        let leftResult = board[0][0] == player && board[1][1] == player && board[2][2] == player
        let rightResult = board[2][0] == player && board[1][1] == player && board[0][2] == player
        if leftResult { return .leftDiagonal }
        if rightResult { return .rightDiagonal }
        return nil
    }
}
