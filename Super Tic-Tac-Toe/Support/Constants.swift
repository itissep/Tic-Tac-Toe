//
//  Constants.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 04.05.2023.
//

import UIKit

struct Constant {
    struct Color {
        static let background = UIColor(named: "BackgroundColor")
        static let accent = UIColor(named: "AccentColor")
        static let white = UIColor(named: "LightColor")
        static let gray = UIColor(named: "GrayColor")?.withAlphaComponent(0.5)
    }
    
    static let xIcon = UIImage(named: "Cross") ?? UIImage()
    static let oIcon = UIImage(named: "Circle") ?? UIImage()

    static let hPadding: CGFloat = 16.0
}
