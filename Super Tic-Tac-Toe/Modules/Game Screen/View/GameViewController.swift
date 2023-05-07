//
//  GameViewController.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 06.05.2023.
//

import UIKit
import Combine

final class GameViewController: UIViewController {
    private lazy var titleLabel = UILabel()
    private lazy var currentPlayerImageView = ImageViewWithInsets(with: 10)
    private lazy var currentPlayerLabel = UILabel()
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var eventSubject = PassthroughSubject<GameEvent, Never>()
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
        eventSubject.send(.fetchGame)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionView()
        configureLabels()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.attachEventListener(with: eventSubject.eraseToAnyPublisher())
        viewModel.$gameTitle
            .receive(on: DispatchQueue.main)
            .map({ $0?.uppercased() })
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
        
        viewModel.$currentPlayer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] player in
                guard let player else { return }
                self?.configureCurrentPlayer(with: player)
            }
            .store(in: &subscriptions)
    }
    
    private func configureCurrentPlayer(with player: Player) {
        let image = player.getImage()
        currentPlayerImageView.imageView.image = image
    }
    
    // MARK: - UI
    
    private func generalSetup() {
        title = "GAME"
        view.backgroundColor = Constant.Color.background
    }
    
    private func configureLabels() {
        currentPlayerLabel.textColor = Constant.Color.white
        currentPlayerLabel.numberOfLines = 0
        currentPlayerLabel.text = "Current\nplayer".uppercased()
        currentPlayerLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        currentPlayerLabel.textAlignment = .center
        
        currentPlayerImageView.backgroundColor = Constant.Color.gray
        currentPlayerImageView.layer.cornerRadius = 16
        currentPlayerImageView.layer.masksToBounds = true
    
        view.addSubviews([titleLabel, currentPlayerLabel, currentPlayerImageView])
    
        NSLayoutConstraint.activate([
            currentPlayerImageView.widthAnchor.constraint(equalToConstant: 75),
            currentPlayerImageView.heightAnchor.constraint(equalToConstant: 75),
            currentPlayerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentPlayerImageView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Constant.hPadding)
        ])
        
        NSLayoutConstraint.activate([
            currentPlayerLabel.topAnchor.constraint(equalTo: currentPlayerImageView.bottomAnchor, constant: 5),
            currentPlayerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.hPadding),
            currentPlayerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentPlayerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.hPadding),
        ])
    }
    
    
    private func configureCollectionView() {
        collectionView.register(GameCollectionCell.self,
                                forCellWithReuseIdentifier: GameCollectionCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = Constant.Color.background
        collectionView.layer.cornerRadius = 16
        collectionView.layer.masksToBounds = true
        
        let side = view.frame.width - 2 * Constant.hPadding
        
        view.addSubviews([collectionView])
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: side),
            collectionView.heightAnchor.constraint(equalToConstant: side),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150)
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventSubject.send(.moveWasMade(at: indexPath))
    }
}

// MARK: - UICollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionCell.identifier, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - layout.minimumInteritemSpacing
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
