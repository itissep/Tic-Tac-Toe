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
    let lastActivity: Date?
    let isFinished: Bool
    
    init(from model: GameModel) {
        self.title = model.title
        self.currentPlayer = model.lastMove?.player ?? .X
        self.id = model.id
        self.lastActivity = model.lastActivity
        self.isFinished = model.isFinished
    }
}
