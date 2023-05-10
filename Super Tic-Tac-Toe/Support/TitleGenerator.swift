//
//  TitleGenerator.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

struct TitleGenerator {
    static let adjectives = ["heroic", "fearless", "epic", "fabulous", "unreal", "cool", "super"]
    
    static func randomTitle() -> String {
        let abjective = adjectives.randomElement() ?? ""
        return "\(abjective) GAME"
    }
}
