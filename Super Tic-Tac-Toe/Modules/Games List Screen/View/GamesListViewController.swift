//
//  GamesListViewController.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 04.05.2023.
//

import UIKit
import Combine

final class GamesListViewController: UIViewController {
    private lazy var tableView = UITableView()
    private lazy var newGameButton = UIButton()
    private lazy var emptyLabel = UILabel()
    
    private var cellsNumber: Int = 0
    
    private var eventSubject = PassthroughSubject<GameListEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: GamesListViewModelDescription
    
    // MARK: - Life Cycle
    
    init(viewModel: GamesListViewModelDescription) {
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
        eventSubject.send(.update)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: Constant.Color.white ?? UIColor.white,
            .font: UIFont.systemFont(ofSize: 35, weight: .black)
        ]
        
        eventSubject.send(.update)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupEmptyLabel()
        setupTableView()
        setupButton()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.attachEventListener(with: eventSubject.eraseToAnyPublisher())
        viewModel.gamesCellsPublisher
            .sink {[weak self] cells in
                self?.emptyLabel.isHidden = !cells.isEmpty
                self?.cellsNumber = cells.count
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - UI
    
    private func generalSetup() {
        view.backgroundColor = Constant.Color.background
        title = "My Games"
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(GameTableCell.self, forCellReuseIdentifier: GameTableCell.identifier)
        
        tableView.estimatedRowHeight = 75 + Constant.hPadding
        
        tableView.backgroundColor = Constant.Color.background
        tableView.separatorStyle = .none
        
        view.addSubviews([tableView])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupEmptyLabel() {
        emptyLabel.text = "There is no games yet.\nGo ahead and create one!"
        emptyLabel.numberOfLines = 0
        emptyLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = Constant.Color.gray
        
        emptyLabel.layer.zPosition = 100
        
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.hPadding),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.hPadding),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupButton() {
        newGameButton.addTarget(self, action: #selector(newGameButtonPressed), for: .touchUpInside)
        
        newGameButton.setTitle("NEW GAME", for: .normal)
        newGameButton.setTitleColor(Constant.Color.white, for: .normal)
        
        newGameButton.backgroundColor = Constant.Color.accent
        newGameButton.layer.cornerRadius = 16
        newGameButton.layer.masksToBounds = true
        newGameButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17, weight: .bold)
        
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
        eventSubject.send(.createNew)
    }
}

// MARK: - UITableViewDelegate

extension GamesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventSubject.send(.select(indexPath: indexPath))
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            eventSubject.send(.delete(indexPath: indexPath))
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        60 + Constant.hPadding
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}

// MARK: - UITableViewDataSource

extension GamesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsNumber
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
