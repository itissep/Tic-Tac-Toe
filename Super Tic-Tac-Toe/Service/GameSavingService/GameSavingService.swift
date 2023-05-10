//
//  GameSavingService.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation
import Combine

protocol GameSavingServiceDescription {
    func createNew(_ completion: @escaping (Result<String, Error>) -> Void)
    func updateAfterMove(withId id: String,
                         move: Move,
                         board: [[Player?]],
                         _ completion: @escaping (Result<Void, Error>) -> Void)
    func fetchGame(withId id: String, _ completion: @escaping (Result<GameModel, Error>) -> Void)
    func fetchAllGames( _ completion: @escaping (Result<[GameModel], Error>) -> Void)
    func deleteGame(with id: String,  _ completion: @escaping (Result<Void , Error>) -> Void)
}

final class GameSavingService: GameSavingServiceDescription {
    private let coreDataService: CoreDataManagerDescrption
    init(coreDataService: CoreDataManagerDescrption) {
        self.coreDataService = coreDataService
        
    }
    
    func createNew(_ completion: @escaping (Result<String, Error>) -> Void) {
        let id = UUID().uuidString
        let title = TitleGenerator.randomTitle()
        self.coreDataService.initIfNeeded {
            self.coreDataService.create(entityName: "GameModelMO") { modelMO in
                guard let modelMO = modelMO as? GameModelMO else { return }

                modelMO.title = title
                modelMO.id = id
                modelMO.lastX = 0
                modelMO.lastY = 0
                modelMO.lastPlayer = " "
                modelMO.lastActivity = Date.now
                modelMO.isFinished = false
                modelMO.board = Array(repeating: " ", count: 9)
            }
            completion(.success(id))
        } errorBlock: { error in
            debugPrint("[DEBUG] core data error \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func updateAfterMove(withId id: String,
                         move: Move,
                         board: [[Player?]],
                         _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        self.coreDataService.initIfNeeded { [ weak self] in
                let fetchRequest = GameModelMO.fetchRequest()
                        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                self?.coreDataService.update(reqeust: fetchRequest, configurationBlock: { gameModel in
                    gameModel?.lastActivity = Date.now
                    gameModel?.lastY = Int32(move.location.y)
                    gameModel?.lastX = Int32(move.location.x)
                    gameModel?.lastPlayer = move.player.rawValue
                    gameModel?.board = GameModel.rawBoard(from: board)
                })
            completion(.success(()))
        } errorBlock: { error in
            debugPrint("[DEBUG] core data error \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func fetchGame(withId id: String, _ completion: @escaping (Result<GameModel, Error>) -> Void) {
        coreDataService.initIfNeeded { [weak self] in
            guard let self else { return }

            let request = GameModelMO.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let modelMO = self.coreDataService.fetch(request: request).first

            guard let modelMO else { return }
            let gameModel = GameModel(from: modelMO)
            completion(.success(gameModel))

        } errorBlock: { error in
            completion(.failure(error))
        }

    }

    func fetchAllGames( _ completion: @escaping (Result<[GameModel], Error>) -> Void) {
        coreDataService.initIfNeeded { [weak self] in
            let request = GameModelMO.fetchRequest()
            let gamesEntities = self?.coreDataService.fetch(request: request)
            let gamesModels = gamesEntities?.map({ GameModel(from: $0) }) ?? []
            completion(.success(gamesModels))
        } errorBlock: { error in
            completion(.failure(error))
        }
    }
    
    func deleteGame(with id: String,  _ completion: @escaping (Result<Void , Error>) -> Void) {
        coreDataService.initIfNeeded { [weak self] in
            guard let self else { return }
            
            let fetchRequest = GameModelMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            self.coreDataService.delete(request: fetchRequest)
            completion(.success(()))
        } errorBlock: { error in
            completion(.failure(error))
        }
    }
}
