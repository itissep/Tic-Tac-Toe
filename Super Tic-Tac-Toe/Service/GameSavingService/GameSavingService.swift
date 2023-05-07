//
//  GameSavingService.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation
import Combine

protocol GameSavingServiceDescription {
    func createNew(withId id: String, withTitle title: String)
    func updateAfterMove(withId id: String, move: Move, _ completion: @escaping (Result<Void, Error>) -> Void)
    func fetchGame(withId id: String, _ completion: @escaping (Result<GameModel, Error>) -> Void)
}

final class GameSavingService: GameSavingServiceDescription {
    init() {
        
    }
    
    func createNew(withId id: String, withTitle title: String) {
    }
    
    func updateAfterMove(withId id: String, move: Move, _ completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func fetchGame(withId id: String, _ completion: @escaping (Result<GameModel, Error>) -> Void) {
        completion(.success(MockData.game))
    }
}
