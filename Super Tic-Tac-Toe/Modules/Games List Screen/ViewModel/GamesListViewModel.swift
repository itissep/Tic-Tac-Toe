//
//  GamesListViewModel.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 06.05.2023.
//

import Foundation
import Combine

protocol GamesListViewModelDescription {
    var gamesCellModels: [GameCellModel] { get }
    var gamesCellsPublisher: Published<[GameCellModel]>.Publisher { get }
    func attachEventListener(with subject: AnyPublisher<GameListEvent, Never>)
}

final class GamesListViewModel: NSObject, GamesListViewModelDescription {
    var gamesCellsPublisher: Published<[GameCellModel]>.Publisher { $gamesCellModels }
    @Published var gamesCellModels: [GameCellModel] = []
    
    private var eventPublisher: AnyPublisher<GameListEvent, Never> = PassthroughSubject<GameListEvent, Never>().eraseToAnyPublisher()
    private var subscriptions = Set<AnyCancellable>()
    
    private let coordinator: BaseCoordinatorDescription
    #warning("TODO: DI")
    private let gameSavingService: GameSavingServiceDescription = GameSavingService()
    
    init(coordinator: BaseCoordinatorDescription) {
        self.coordinator = coordinator
        super.init()
    }
    
    func attachEventListener(with subject: AnyPublisher<GameListEvent, Never>) {
        self.eventPublisher = subject
        eventPublisher
            .sink { [weak self] event in
                switch event {
                case .createNew:
                    self?.createNewGame()
                case .delete(let indexPath):
                    self?.deleteGame(at: indexPath)
                case .update:
                    self?.fetchGames()
                case .select(let indexPath):
                    self?.gameWasSelected(at: indexPath)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func fetchGames() {
        gameSavingService.fetchAllGames {[weak self] result in
            switch result {
            case .success(let models):
                self?.toCellModels(models)
            case .failure(let error):
                print(error)
            }
        }
    }
    #warning("TODO: add date and normal init")
    private func toCellModels(_ models: [GameModel]) {
        let cellModels = models.map { model in
            GameCellModel(title: model.title, currentPlayer: model.lastMove?.player ?? .X, id: model.id, lastActivity: Date.now, isFinished: model.isFinished)
        }
        gamesCellModels = cellModels
    }
    
    private func createNewGame() {
        gameSavingService.createNew {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newGameId):
                DispatchQueue.main.async {
                    self?.fetchGames()
                    self?.coordinator.goToGame(with: newGameId)
                }
            }
        }
    }
    
    private func deleteGame(at indexPath: IndexPath) {
        let gameId = gamesCellModels[indexPath.row].id
        gamesCellModels.remove(at: indexPath.row)
        gameSavingService.deleteGame(with: gameId) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let something):
                break
            }
        }
    }
    
    private func gameWasSelected(at indexPath: IndexPath) {
        let gameId = gamesCellModels[indexPath.row].id
        coordinator.goToGame(with: gameId)
    }
}
