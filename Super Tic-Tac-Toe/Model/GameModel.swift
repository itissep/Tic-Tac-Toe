//
//  GameModel.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 08.05.2023.
//

import Foundation

struct GameModel {
    let id: String
    let title: String
    let board: [[Player?]]
    let lastMove: Move?
    let lastActivity: Date?
    let isFinished: Bool

    init(from modelDB: GameModelMO) {
        self.id = modelDB.id ?? ""
        self.title = modelDB.title ?? "SOME GAME"
        self.isFinished = modelDB.isFinished
        self.lastMove = Self.lastMove(from: modelDB)
        self.board = Self.board(from: modelDB.board)
        self.lastActivity = modelDB.lastActivity
    }
    
    static func lastMove(from data: GameModelMO) -> Move? {
        let x = Int(data.lastX)
        let y = Int(data.lastY)
        if let player = Player.from(data.lastPlayer) {
            return Move(location: (x, y), player: player)
        } else {
            return nil
        }
    }
    
    static func board(from data: [String]?) -> [[Player?]] {
        guard let data else { return emptyBoard() }
        var boardItems: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        
        for i in 0...8 {
            let x = i % 3
            let y = Int(i/3)
            boardItems[x][y] = Player.from(data[i])
        }
        return boardItems
    }
    
    static func rawBoard(from board: [[Player?]]) -> [String] {
        var rawBoard: [String] = []
        for y in 0...2 {
            for x in 0...2 {
                let rawPlayer = board[x][y]?.rawValue ?? " "
                rawBoard.append(rawPlayer)
            }
        }
        return rawBoard
    }
    
    static func emptyBoard() -> [[Player?]] {
        Array(repeating: Array(repeating: nil, count: 3), count: 3)
    }
}
