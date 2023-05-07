//
//  BoardEvent.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

enum BoardEvent {
    case newGame(String,[[Player?]])
    case gameFetched([[Player?]], Player)
    case placeIsTaken
    case gameFinishedWithDraw
    case gameFinishedWithWinner(Player, WinningDirection)
    case updateWith([[Player?]])
    case error
    case changePlayer
}