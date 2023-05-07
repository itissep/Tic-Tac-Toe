//
//  GameCollectionCell.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import UIKit

final class GameCollectionCell: UICollectionViewCell {
    class var identifier: String { return String(describing: self) }
    
    private lazy var iconImageView = ImageViewWithInsets(with: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?) {
        guard image != nil else { return }
        iconImageView.imageView.image = image
    }
    
    private func layout() {
        contentView.backgroundColor = Constant.Color.gray
        contentView.addSubviews([iconImageView])
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.imageView.image = nil
    }
}
