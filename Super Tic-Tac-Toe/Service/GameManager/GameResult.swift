//
//  WinningDirection.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

enum GameResult: Equatable {
    case row(Int)
    case column(Int)
    case rightDiagonal
    case leftDiagonal
    case draw
}
