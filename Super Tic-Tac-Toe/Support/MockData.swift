//
//  MockData.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 04.05.2023.
//

import UIKit
#warning("TODO: get rid of moves everywhere")
struct MockData {
    static let cellModel = GameCellModel(title: "Something", currentPlayer: .O, id: "id", lastActivity: Date.now, isFinished: false)
    static let cells = [cellModel, cellModel, cellModel]
    
    static let game = GameModel(title: "Game 1", board: [[nil,nil,nil],[nil,nil,nil],[nil,nil,nil]],lastMove: Move(location: (0,0), player: .X), isFinished: false)
}

struct GameModel {
    let title: String
    let board: [[Player?]]
    let lastMove: Move
    let isFinished: Bool
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
    
    func getColor() -> UIColor {
        switch self {
        case .O: return Constant.Color.white ?? .white
        case .X: return Constant.Color.accent ?? .white
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

//class Board {
//    var localBoxes: [[Player?]] = []
//    var globalBoxes: [[Player?]] = []
//    
//    func createNew() {
//        var newBoxes = [[Player?]]()
//        for x in 0...9 {
//            for y in 0...9 {
//                newBoxes[x][y] = nil
//            }
//        }
//        localBoxes = newBoxes
//    }
//    
//    func moveAt(x: Int, y: Int, player: Player, board: BoardType) {
//        if board == .Global {
//            globalBoxes[x][y] = player
//        } else {
//            localBoxes[x][y] = player
//        }
//    }
//    
//    func checkLocalBoard(x: Int, y: Int) {
//        
//    }
//    
//    func checkGlobalBoard() {
//        
//    }
//    
//    func checkGame() {
//        
//    }
//    
//}
