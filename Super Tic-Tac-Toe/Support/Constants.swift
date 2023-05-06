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
        static let gray = UIColor(named: "GrayColor")
    }
    
    struct Font {
        static let title = UIFont.systemFont(ofSize: 20)
        static let common = UIFont.systemFont(ofSize: 15)
        static let capture = UIFont.systemFont(ofSize: 13)
    }
    
    static let xIcon = UIImage(systemName: "cross.fill")
    static let oIcon = UIImage(systemName: "smallcircle.filled.circle")

    static let hPadding: CGFloat = 16.0
}
