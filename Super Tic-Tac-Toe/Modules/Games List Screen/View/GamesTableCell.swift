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
    private lazy var currentPlayerView = ImageViewWithInsets(with: 10)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellModel: GameCellModel) {
        let time = cellModel.lastActivity.timeToShow() ?? "maybe today"
        titleLabel.text = cellModel.title.uppercased()
        dateLabel.text = time
        configureCurrentPlayer(with: cellModel.currentPlayer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentPlayerView.imageView.image = nil
    }
    
    private func layout() {
        contentView.addSubviews([titleLabel, dateLabel, currentPlayerView])
        contentView.backgroundColor = Constant.Color.background
        
        currentPlayerView.backgroundColor = Constant.Color.gray
        currentPlayerView.layer.cornerRadius = 16
        currentPlayerView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .black)
        titleLabel.textColor = Constant.Color.accent
        
        dateLabel.textColor = Constant.Color.gray
        dateLabel.textColor = Constant.Color.white
        
        NSLayoutConstraint.activate([
            currentPlayerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.hPadding),
            currentPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.hPadding),
            currentPlayerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.hPadding),
            currentPlayerView.widthAnchor.constraint(equalToConstant: 75),
            currentPlayerView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.hPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constant.hPadding),
            titleLabel.leadingAnchor.constraint(equalTo: currentPlayerView.trailingAnchor, constant: Constant.hPadding),
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constant.hPadding),
            dateLabel.leadingAnchor.constraint(equalTo: currentPlayerView.trailingAnchor, constant: Constant.hPadding),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
        ])
    }
    
    private func configureCurrentPlayer(with player: Player) {
        let image = player.getImage()
        currentPlayerView.imageView.image = image
        currentPlayerView.imageView.contentMode = .scaleAspectFit
    }
}
