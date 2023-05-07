//
//  GameListEvent.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

enum GameListEvent {
    case delete(indexPath: IndexPath)
    case update
    case select(indexPath: IndexPath)
    case createNew
}
