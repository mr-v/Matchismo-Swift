//
//  CardViewModel.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

// MARK: Extensions

extension PlayingCard: Printable {
    var description: String {
        get {
            let letterMapping: [Rank: String] = [.Ace: "A", .Jack: "J", .Queen: "Q", .King: "K"]

            var rankText: String
            switch letterMapping[rank] {
            case nil:
                rankText = String(rank.rawValue)
            case let mappedText:
                rankText = mappedText!
            }
            let s = suit.rawValue
            return rankText + s
        }
    }
}

// MARK:

class CardViewModel {
    private let game: MatchingGame
    internal private(set) var currentCardTitle: String = ""

    var scoreText: String {
        get {
            return "Score: \(game.score)"
        }
    }

    init(game: MatchingGame) {
        self.game = game
    }

}