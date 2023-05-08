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
#warning("TODO: move to DI")
    private let coreDataService: CoreDataManagerDescrption = CoreDataManager.shared
    init() {
        
    }
    
    func createNew(_ completion: @escaping (Result<String, Error>) -> Void) {
        let id = UUID().uuidString
        let title = TitleGenerator.randomTitle()
        self.coreDataService.initIfNeeded {
            self.coreDataService.create(entityName: "GameModelMO") { productMO in
                guard let productMO = productMO as? GameModelMO else {
                    return
                }

                productMO.title = title
                productMO.id = id
                productMO.lastX = 0
                productMO.lastY = 0
                productMO.lastPlayer = " "
                productMO.isFinished = false
                #warning("TODO: add board")
//                productMO.board = Array(repeating: " ", count: 9)

                completion(.success(id))
            }
        } errorBlock: { error in
            debugPrint("[DEBUG] core data error \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func updateAfterMove(withId id: String,
                         move: Move,
                         board: [[Player?]],
                         _ completion: @escaping (Result<Void, Error>) -> Void) {
        
//        self.coreDataService.initIfNeeded { [ weak self] in
////            if let rawGameModels = self?.coreDataService.fetch(request: GameModelMO.fetchRequest()) {
//                let fetchRequest = GameModelMO.fetchRequest()
//                        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
////            if let rawGameModel = self?.coreDataService.fetch(request: fetchRequest).first {
//                self?.coreDataService.update(reqeust: fetchRequest, configurationBlock: { gameModel in
//                    gameModel?.lastY = Int32(move.location.y)
//                    gameModel?.lastX = Int32(move.location.x)
//                    gameModel?.lastPlayer = move.player.rawValue
//                    #warning("TODO: add board")
////                    gameModel?.board = GameModel.rawBoard(from: board)
//                })
////            }
//            completion(.success(()))
//        } errorBlock: { error in
//            debugPrint("[DEBUG] core data error \(error.localizedDescription)")
//            completion(.failure(error))
//        }

        
    }
    
    func fetchGame(withId id: String, _ completion: @escaping (Result<GameModel, Error>) -> Void) {
//        coreDataService.initIfNeeded { [weak self] in
//            guard let self else { return }
//
//            let request = GameModelMO.fetchRequest()
//            let productMO = self.coreDataService.fetch(request: request).first
//
//            guard let productMO else { return }
//            let product = GameModel(from: productMO)
//            completion(.success(product))
//
//        } errorBlock: { error in
//            completion(.failure(error))
//        }

    }
    #warning("TODO: raname")
    func fetchAllGames( _ completion: @escaping (Result<[GameModel], Error>) -> Void) {
        coreDataService.initIfNeeded { [weak self] in
            let request = GameModelMO.fetchRequest()
            let channelsEntities = self?.coreDataService.fetch(request: request)
            let channelModels = channelsEntities?.map({ GameModel(from: $0) }) ?? []
            completion(.success(channelModels))
        } errorBlock: { error in
            print(error)
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
