//
//  Move.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

final class Move {
    var location: (x: Int, y: Int)
    var player: Player
    
    init(location: (x: Int, y: Int), player: Player) {
        self.location = location
        self.player = player
    }
}
