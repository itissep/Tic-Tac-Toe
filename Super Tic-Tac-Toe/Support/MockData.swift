//
//  MockData.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 04.05.2023.
//

import UIKit

struct MockData {
    static let cellModel = GameCellModel(title: "Something", progress: 12, currentPlayer: .O, id: "id", lastActivity: Date.now, isFinished: false)
    static let cells = [cellModel, cellModel, cellModel]
    
    static let game = GameModel(title: "Game 1", numberOfMoves: 2, board: [[.O]], currentPlayer: .O, isFinished: false)
}


enum Player {
    case X
    case O
    
    func enemy() -> Player {
        switch self {
        case .O: return .X
        case .X: return .O
        }
    }
    
    func getImage() -> UIImage {
        switch self {
        case .O: return Constant.oIcon
        case .X: return Constant.xIcon
        }
    }
}

enum BoardType {
    case Local
    case Global
}

class Location {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

class Box {
    let x: Int
    let y: Int
    var player: Player?
    
    init(x: Int, y: Int, player: Player? = nil) {
        self.x = x
        self.y = y
        self.player = player
    }
}

class Board {
    var localBoxes: [[Player?]] = []
    var globalBoxes: [[Player?]] = []
    
    func createNew() {
        var newBoxes = [[Player?]]()
        for x in 0...9 {
            for y in 0...9 {
                newBoxes[x][y] = nil
            }
        }
        localBoxes = newBoxes
    }
    
    func moveAt(x: Int, y: Int, player: Player, board: BoardType) {
        if board == .Global {
            globalBoxes[x][y] = player
        } else {
            localBoxes[x][y] = player
        }
    }
    
    func checkLocalBoard(x: Int, y: Int) {
        
    }
    
    func checkGlobalBoard() {
        
    }
    
    func checkGame() {
        
    }
    
}

struct GameModel {
    let title: String
    let numberOfMoves: Int
    let board: [[Player]]
    let currentPlayer: Player
    let isFinished: Bool
}
