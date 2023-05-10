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
    var deleteResult: AnyPublisher<IndexPath, Never> { get }
    
    func attachEventListener(with subject: AnyPublisher<GameListEvent, Never>)
}

final class GamesListViewModel: NSObject, GamesListViewModelDescription {
    var gamesCellsPublisher: Published<[GameCellModel]>.Publisher { $gamesCellModels }
    @Published var gamesCellModels: [GameCellModel] = []
    var deleteResult: AnyPublisher<IndexPath, Never> {
        deleteResultSubject.eraseToAnyPublisher()
    }
    
    private var deleteResultSubject = PassthroughSubject<IndexPath, Never>()
    private var eventPublisher: AnyPublisher<GameListEvent, Never> = PassthroughSubject<GameListEvent, Never>().eraseToAnyPublisher()
    private var subscriptions = Set<AnyCancellable>()
    
    private let coordinator: BaseCoordinatorDescription
    private let gameSavingService: GameSavingServiceDescription
    
    init(coordinator: BaseCoordinatorDescription,
         gameService: GameSavingServiceDescription) {
        self.coordinator = coordinator
        self.gameSavingService = gameService
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
    
    private func toCellModels(_ models: [GameModel]) {
        let cellModels = models.map { GameCellModel(from: $0) }
        gamesCellModels = sortByDate(cellModels)
    }
    
    private func sortByDate(_ cells: [GameCellModel]) -> [GameCellModel] {
        return cells.sorted { first, second in
            guard
                let firstDate = first.lastActivity,
                let secondDate = second.lastActivity
            else { return false }
                  
            return firstDate > secondDate
        }
    }
    
    private func createNewGame() {
        gameSavingService.createNew {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newGame):
                DispatchQueue.main.async {
                    self?.fetchGames()
                    self?.coordinator.goToGame(with: newGame.id, title: newGame.title)
                }
            }
        }
    }
    
    private func deleteGame(at indexPath: IndexPath) {
        let gameId = gamesCellModels[indexPath.row].id
        gamesCellModels.remove(at: indexPath.row)
        gameSavingService.deleteGame(with: gameId) {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                self?.deleteResultSubject.send(indexPath)
            }
        }
    }
    
    private func gameWasSelected(at indexPath: IndexPath) {
        let gameId = gamesCellModels[indexPath.row].id
        let gameTitle = gamesCellModels[indexPath.row].title

        coordinator.goToGame(with: gameId, title: gameTitle)
    }
}
