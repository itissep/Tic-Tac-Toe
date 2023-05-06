//
//  GamesTableCell.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 06.05.2023.
//

import UIKit

final class GameTableCell: UITableViewCell {
    class var identifier: String { return String(describing: self) }
    
    private lazy var titleLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var progressLabel = UILabel()
    private lazy var currentPlayerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubviews([titleLabel, dateLabel, progressLabel, currentPlayerView])
        contentView.backgroundColor = Constant.Color.background
        
        currentPlayerView.backgroundColor = Constant.Color.accent
        currentPlayerView.layer.cornerRadius = 50 / 2
        currentPlayerView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .black)
        titleLabel.textColor = Constant.Color.accent
        
        dateLabel.textColor = Constant.Color.gray
        progressLabel.textColor = Constant.Color.white
        
        NSLayoutConstraint.activate([
            currentPlayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.hPadding),
            currentPlayerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currentPlayerView.widthAnchor.constraint(equalToConstant: 50),
            currentPlayerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.hPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.hPadding),
            titleLabel.trailingAnchor.constraint(equalTo: currentPlayerView.leadingAnchor, constant: Constant.hPadding),
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.hPadding),
            progressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.hPadding),
            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.hPadding),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.hPadding),
            dateLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.hPadding)
        ])
    }
    
    private func configureCurrentPlayer(with value: Int) {
        
    }
    
    func configure(with cellModel: GameCellModel) {
        let time = cellModel.lastActivity.timeToShow() ?? "maybe today"
        titleLabel.text = cellModel.title.uppercased()
        dateLabel.text = time
        progressLabel.text = "Moves: \(cellModel.progress)"
        configureCurrentPlayer(with: cellModel.currentPlayer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
