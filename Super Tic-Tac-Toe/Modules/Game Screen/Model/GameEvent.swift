//
//  GameEvent.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

enum GameEvent {
    case fetchGame
    case moveWasMade(at: IndexPath)
}
