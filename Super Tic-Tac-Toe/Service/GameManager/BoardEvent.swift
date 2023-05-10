//
//  BoardEvent.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

enum BoardEvent {
    case gameFetched([[Player?]], Player, String)
    case placeIsTaken
    case gameFinished(GameResult)
    case updateWith([[Player?]])
    case error
    case changePlayer
}
