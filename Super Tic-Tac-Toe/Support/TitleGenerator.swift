//
//  TitleGenerator.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 07.05.2023.
//

import Foundation

struct TitleGenerator {
    static let adjectives = ["heroic", "fearless", "epic", "fabulous", "unreal"]
    static let nouns = ["struggle", "conflict", "battle", "contest", "match", "round"]
    
    static func randomTitle() -> String {
        let abjective = adjectives.randomElement() ?? ""
        let noun = nouns.randomElement() ?? ""
        return "\(abjective) \(noun)"
    }
}
