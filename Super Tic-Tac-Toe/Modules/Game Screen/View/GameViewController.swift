//
//  GameViewController.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 06.05.2023.
//

import UIKit
import Combine

final class GameViewController: UIViewController {
    lazy var titleLabel = UILabel()
    lazy var movesLabel = UILabel()
    lazy var currentPlayerLabel = UILabel()
    lazy var collectionView = UIView()
    
    private let viewModel: GameViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generalSetup()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: Constant.Color.accent ?? UIColor.white,
            .font: UIFont.systemFont(ofSize: 35, weight: .black)
        ]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureLabels()
        configureCollectionView()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.$gameTitle
            .receive(on: DispatchQueue.main)
            .map({ $0?.uppercased() })
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
        
        viewModel.$movesNumber
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movesNumber in
                guard let movesNumber else { return }
                self?.configureMovesLabel(with: movesNumber)
            }
            .store(in: &subscriptions)
        
        viewModel.$currentPlayer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] player in
                guard let player else { return }
                self?.configureCurrentPlayer(with: player)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - UI
    
    private func configureMovesLabel(with number: Int) {
        movesLabel.text = "Moves: \(number)"
    }
    
    private func configureCurrentPlayer(with player: Player) {
        
    }
    
    private func generalSetup() {
        view.backgroundColor = Constant.Color.background
    }
    
    private func configureLabels() {
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .black)
        titleLabel.textColor = Constant.Color.accent
        
        movesLabel.textColor = Constant.Color.white
        
        currentPlayerLabel.textColor = Constant.Color.gray
        currentPlayerLabel.text = "Current player: "
        
        view.addSubviews([titleLabel, movesLabel, currentPlayerLabel])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.hPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.hPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.hPadding),
        ])
        
        NSLayoutConstraint.activate([
            movesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constant.hPadding),
            movesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.hPadding),
            movesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.hPadding),
        ])
        
        NSLayoutConstraint.activate([
            currentPlayerLabel.topAnchor.constraint(equalTo: movesLabel.bottomAnchor, constant: Constant.hPadding),
            currentPlayerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.hPadding),
            currentPlayerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.hPadding),
        ])
    }

    
    private func configureCollectionView() {
        collectionView.layer.cornerRadius = 16
        collectionView.layer.masksToBounds = true
        collectionView.backgroundColor = Constant.Color.gray
        
        let side = view.frame.width - 2 * Constant.hPadding
        
        view.addSubviews([collectionView])
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: side),
            collectionView.heightAnchor.constraint(equalToConstant: side),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constant.hPadding)
        ])
    }
}
