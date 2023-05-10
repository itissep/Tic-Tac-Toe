//
//  BoardEvent.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

enum BoardEvent: Equatable {
    case gameFetched([[Player?]], Player)
    case placeIsTaken
    case gameFinished(GameResult)
    case updateWith([[Player?]])
    case error
    case changePlayer
}
