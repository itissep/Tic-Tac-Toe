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
    private lazy var gameResultView = UIView()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var cellSize: CGFloat?
    
    private var moveWasMadeSubject = PassthroughSubject<IndexPath, Never>()
    private let viewModel: GameViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(viewModel: GameViewModel, title: String) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.title = title.uppercased()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generalSetup()
        setupBinding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionView()
        configureLabels()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.attachEventListener(with: moveWasMadeSubject.eraseToAnyPublisher())
        
        viewModel.$currentPlayer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] player in
                guard let player else { return }
                self?.configurePlayer(with: player)
            }
            .store(in: &subscriptions)
        
        viewModel.$cellModels
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$gameResult
            .sink { [weak self] gameResult in
                guard let gameResult else { return }
                self?.configureGameResult(with: gameResult)
            }
            .store(in: &subscriptions)
    }
    
    private func configurePlayer(with player: Player) {
        let image = player.getImage()
        currentPlayerImageView.imageView.image = image
    }
    
    // MARK: - UI
    
    private func generalSetup() {
        view.backgroundColor = Constant.Color.background
    }
    
    private func configureLabels() {
        currentPlayerLabel.textColor = Constant.Color.white
        currentPlayerLabel.numberOfLines = 0
        currentPlayerLabel.text = "player".uppercased()
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
    
    private func configureGameResult(with result: GameResult) {
        gameResultView.layer.cornerRadius = 16
        gameResultView.layer.masksToBounds = true
        gameResultView.backgroundColor = Constant.Color.background?.withAlphaComponent(0.5)
        gameResultView.layer.zPosition = 100
        view.addSubviews([gameResultView])
        
        let side = view.frame.width - 2 * Constant.hPadding
        
        NSLayoutConstraint.activate([
            gameResultView.widthAnchor.constraint(equalToConstant: side),
            gameResultView.heightAnchor.constraint(equalToConstant: side),
            gameResultView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            gameResultView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let player = viewModel.currentPlayer ?? .O
        configureGameResultLabel(with: result, player: player)
    }
    
    private func configureGameResultLabel(with result: GameResult, player: Player) {
        let color = player.getColor()
        let view = UIView()
        view.layer.borderWidth = 10
        view.layer.borderColor = color.cgColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = result == .draw ? "DRAW" : "WIN WIN WIN"
        label.font = UIFont.systemFont(ofSize: 45, weight: .black)
        label.textColor = color

        gameResultView.addSubviews([view])
        view.addSubviews([label])
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: gameResultView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: gameResultView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
        ])
        transformView(view, for: result)
    }
    
    private func transformView(_ view: UIView, for result: GameResult) {
        switch result {
        case .row(let number):
            view.transform = CGAffineTransform(translationX: 0, y: getOffset(for: number))
        case .column(let number):
            var transform = CGAffineTransform.identity
            transform = transform.translatedBy(x: getOffset(for: number), y: 0)
            transform = transform.rotated(by: -(.pi / 2))
            view.transform = transform
        case .rightDiagonal:
            view.transform = CGAffineTransform(rotationAngle: -(.pi / 4))
        case .leftDiagonal:
            view.transform = CGAffineTransform(rotationAngle: (.pi / 4))
        case .draw:
            view.transform = CGAffineTransform(rotationAngle: -(.pi / 6))
        }
    }
    
    private func getOffset(for number: Int) -> CGFloat {
        let offset = (view.frame.width - 2 * Constant.hPadding) / 3
        switch number {
        case 0:
            return -offset
        case 2:
            return offset
        default:
            return 0.0
        }
    }
}

// MARK: - UICollectionViewDelegate

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveWasMadeSubject.send(indexPath)
    }
}

// MARK: - UICollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionCell.identifier, for: indexPath)
        guard let cell = cell as? GameCollectionCell else {
            fatalError("Error with GameCollectionCell")
        }
        let playerImage = viewModel.cellModels[indexPath.row]?.getImage()
        cell.setImage(playerImage)
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
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        let widthPerItem = collectionView.frame.width / 3 - layout.minimumInteritemSpacing
        self.cellSize = widthPerItem
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
