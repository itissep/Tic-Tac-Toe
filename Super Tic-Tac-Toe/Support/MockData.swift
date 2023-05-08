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
    let id: String
    let title: String
    let board: [[Player?]]
    let lastMove: Move?
    let isFinished: Bool
    
    #warning("TODO: remove this")
    init(title: String, board: [[Player?]], lastMove: Move, isFinished: Bool) {
        self.id = ""
        self.title = title
        self.board = board
        self.lastMove = lastMove
        self.isFinished = isFinished
    }
    
    init(from modelDB: GameModelMO) {
        self.id = modelDB.id ?? ""
        self.title = modelDB.title ?? "SOME GAME"
        self.isFinished = modelDB.isFinished
        self.lastMove = Self.lastMove(from: modelDB)
        #warning("TODO: add board")
//        self.board = Self.board(from: modelDB.board)
        self.board = Self.emptyBoard()
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
        var boardItems: [[Player?]] = []
        
        for i in 0...9 {
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
        return []
    }
    
    static func emptyBoard() -> [[Player?]] {
        var boardItems: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
//        Array(repeating: Array(repeating: 0, count: 3), count: 3)
//        for x in 0...2 {
//            for y in 0...2 {
//                boardItems[x][y] = nil
//            }
//        }
        return boardItems
    }
    
//    static func emptyRawBoard() -> [String] {
//        var boardItems: [String] = Array(repeating: " ", count: 9)
//        return boardItems
//    }
    
    
}

enum Player: String {
    case X = "X"
    case O = "O"
    
    static func from(_ string: String?) -> Player? {
        switch string {
        case "X":
            return .X
        case "O":
            return .O
        default:
            return nil
        }
    }
    
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
