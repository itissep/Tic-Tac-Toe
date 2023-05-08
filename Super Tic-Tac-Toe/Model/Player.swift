//
//  Player.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 08.05.2023.
//

import UIKit

enum Player: String {
    case X = "X"
    case O = "O"
    
    static func from(_ string: String?) -> Player? {
        switch string {
        case "X": return .X
        case "O": return .O
        default: return nil
        }
    }
    
    func enemy() -> Player {
        switch self {
        case .O: return .X
        case .X: return .O
        }
    }
    
    func getImage() -> UIImage {
        switch self {
        case .O: return Constant.oIcon
        case .X: return Constant.xIcon
        }
    }
    
    func getColor() -> UIColor {
        switch self {
        case .O: return Constant.Color.white ?? .white
        case .X: return Constant.Color.accent ?? .white
        }
    }
}
