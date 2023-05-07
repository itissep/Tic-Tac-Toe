//
//  ImageViewWithInsets.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import UIKit

final class ImageViewWithInsets: UIView {
    lazy var imageView = UIImageView()
    
    init(with inset: CGFloat) {
        super.init(frame: .zero)
        layout(with: inset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(with inset: CGFloat) {
        self.addSubviews([imageView])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset)
        ])
    }
}
