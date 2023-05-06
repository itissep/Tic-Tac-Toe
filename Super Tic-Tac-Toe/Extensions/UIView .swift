//
//  UIView .swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 05.05.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { currentView in
            currentView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(currentView)
        }
    }
}
