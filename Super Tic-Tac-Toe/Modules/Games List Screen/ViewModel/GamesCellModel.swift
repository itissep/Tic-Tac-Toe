//
//  GamesCellModel.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 06.05.2023.
//

import Foundation

final class GameCellModel: NSObject {
    
    let title: String
    let currentPlayer: Player
    let id: String
    let lastActivity: Date
    let isFinished: Bool
    
    init(title: String, currentPlayer: Player, id: String, lastActivity: Date, isFinished: Bool) {
        self.title = title
        self.currentPlayer = currentPlayer
        self.id = id
        self.lastActivity = lastActivity
        self.isFinished = isFinished
    }
    
    init(from model: GameModel) {
        self.title = model.title
        self.currentPlayer = model.lastMove?.player ?? .X
        self.id = model.id
        #warning("TODO: date to model")
        self.lastActivity = Date.now
        self.isFinished = model.isFinished
    }
}
