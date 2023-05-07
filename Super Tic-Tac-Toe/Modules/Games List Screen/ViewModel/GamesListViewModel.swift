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
        gamesCellModels = MockData.cells
    }
    
    private func createNewGame() {
        
    }
    
    private func deleteGame(at indexPath: IndexPath) {
        gamesCellModels.remove(at: indexPath.row)
    }
    
    private func gameWasSelected(at indexPath: IndexPath) {
        let gameId = gamesCellModels[indexPath.row].id
        coordinator.goToGame(with: gameId)
    }
}
