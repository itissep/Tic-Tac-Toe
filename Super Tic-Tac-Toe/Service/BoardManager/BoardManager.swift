//
//  BoardManager.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation
import Combine

final class BoardManager {
    var items: [[Player?]]?
    var lastMove: Move?
    var emptyPlaces: Int = 9
    
    private let id: String
    private let gameSavingService: GameSavingServiceDescription
    
    let eventPublisher = PassthroughSubject<BoardEvent, Never>()
    
    init(gameSavingService: GameSavingServiceDescription) {
        self.gameSavingService = gameSavingService
        
        var boardItems: [[Player?]] = []
        for x in 0...2 {
            for y in 0...2 {
                boardItems[x][y] = nil
            }
        }
        self.items = boardItems
        
        let title = TitleGenerator.randomTitle()
        let id = UUID().uuidString
        self.id = id
        gameSavingService.createNew(withId: id, withTitle: title)
        eventPublisher.send(.newGame(title, boardItems))
    }
    
    init(gameSavingService: GameSavingServiceDescription, gameId: String) {
        self.gameSavingService = gameSavingService
        self.id = gameId
    }
    
    func fetch(with id: String) {
        gameSavingService.fetchGame(withId: id) {[weak self] result in
            switch result {
            case .failure(_):
                break
            case .success(let gameModel):
                self?.configureGame(with: gameModel)
            }
        }
    }
    
    func moveWasMade(player: Player, indexPath: IndexPath) {
        let newMove = Move(location: location(for: indexPath), player: player)
        guard isEmpty(at: newMove.location) else { return }
        placeMove(newMove)
        
        if let winningDerection = isWinningMove() {
            eventPublisher.send(.gameFinishedWithWinner(newMove.player, winningDerection))
        } else if emptyPlaces == 0 {
            eventPublisher.send(.gameFinishedWithDraw)
        } else {
            eventPublisher.send(.changePlayer)
        }
    }
    
    private func configureGame(with gameModel: GameModel) {
        items = gameModel.board
        lastMove = gameModel.lastMove
        getEmptyPlaces()
        
        let currentPlayer = gameModel.lastMove.player.enemy()
        eventPublisher.send(.gameFetched(gameModel.board, currentPlayer))
    }
    
    private func isEmpty(at location: (x: Int, y: Int)) -> Bool {
        guard let items else { return true }
        return items[location.x][location.y] == nil
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
        items?[lastMove.location.x][lastMove.location.y] = lastMove.player
        guard let items else { return }
        gameSavingService.updateAfterMove(withId: id, move: lastMove) {[weak self] result in
            switch result {
            case .success(_):
                self?.eventPublisher.send(.updateWith(items))
            case .failure(_):
                self?.eventPublisher.send(.error)
            }
        }
    }
    
    private func getEmptyPlaces(){
        guard let items else { return }
        var count = 0
        for x in 0...2 {
            for y in 0...2 {
                if items[x][y] == nil { count += 1}
            }
        }
        emptyPlaces = count
    }
    
    private func isWinningMove() -> WinningDirection? {
        let results = [checkColumn(), checkRow(), checkDiagonals()]
        return results.first(where:{ $0 != nil }) ?? nil
    }
    
    private func checkColumn() -> WinningDirection? {
        guard let lastMove, let items else { return nil }
        let player = lastMove.player
        let x = lastMove.location.x
        if  items[x][0] == player &&
                items[x][1] == player &&
                items[x][2] == player {
            return .column(x)
        } else {
            return nil
        }
    }
    
    private func checkRow() -> WinningDirection? {
        guard let lastMove, let items else { return nil }
        let player = lastMove.player
        let y = lastMove.location.y
        if  items[0][y] == player &&
                items[1][y] == player &&
                items[2][y] == player {
            return .row(y)
        } else {
            return nil
        }
    }
    
    private func checkDiagonals() -> WinningDirection? {
        guard let lastMove, let items else { return nil }
        let player = lastMove.player
        let leftResult = items[0][0] == player && items[1][1] == player && items[2][2] == player
        let rightResult = items[2][0] == player && items[1][1] == player && items[0][2] == player
        if leftResult { return .leftDiagonal }
        if rightResult { return .rightDiagonal }
        return nil
    }
}
