//
//  GamesListViewController.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 04.05.2023.
//

import UIKit
import Combine

class GamesListViewControllerr: UIViewController {
    private lazy var tableView = UITableView()
    private lazy var newGameButton = UIButton()
    private lazy var emptyLabel = UILabel()
    
    // MARK: - Life Cycle
    
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: GamesListViewModel
    
    init(viewModel: GamesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        generalSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupEmptyLabel()
        setupTableView()
        setupButton()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.$gamesCellModels
            .sink {[weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - UI
    
    private func generalSetup() {
        view.backgroundColor = Constant.Color.background
        title = "My Games"
        navigationController?.navigationBar.prefersLargeTitles = true
        #warning("TODO: color of title")
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.red
        ]

    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(GameTableCell.self, forCellReuseIdentifier: GameTableCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        tableView.backgroundColor = Constant.Color.background
        tableView.separatorStyle = .none
        
        view.addSubviews([tableView])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupEmptyLabel() {
        emptyLabel.text = "There is no games yet. /nGo ahead and create one!"
        emptyLabel.numberOfLines = 0
        emptyLabel.font = Constant.Font.capture
        emptyLabel.textColor = Constant.Color.gray
        
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constant.hPadding),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.hPadding),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupButton() {
        newGameButton.addTarget(self, action: #selector(newGameButtonPressed), for: .touchUpInside)
        
        newGameButton.setTitle("NEW GAME", for: .normal)
        newGameButton.setTitleColor(Constant.Color.background, for: .normal)
        
        newGameButton.backgroundColor = Constant.Color.accent
        newGameButton.layer.cornerRadius = 16
        newGameButton.layer.masksToBounds = true
        
        view.addSubview(newGameButton)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            newGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.hPadding),
            newGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.hPadding),
            newGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Selectors
    @objc
    private func newGameButtonPressed() {
        viewModel.createNewGame()
    }
}

// MARK: - UITableViewDelegate

extension GamesListViewControllerr: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteGame(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSource

extension GamesListViewControllerr: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.gamesCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableCell.identifier, for: indexPath)
        guard let cell = cell as? GameTableCell else {
            fatalError("Error with Conversation Table Cell")
        }
        let cellViewModel = viewModel.gamesCellModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
}
