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
                rankText = String(rank.toRaw())
            case let mappedText:
                rankText = mappedText!
            }
            let s = suit.toRaw()
            return rankText + s
        }
    }
}

// MARK:

class CardViewModel {
    private let gameStats: GameStats
    private let deck: Deck
    internal private(set) var currentCardTitle: String = ""
    var isDeckEmpty: Bool {
        get {
            return deck.isEmpty
        }
    }

    init(gameStats stats: GameStats, deck: Deck = Deck()) {
        gameStats = stats
        self.deck = deck
        updateCurrentCardTitle()
    }

    func flipCountText() -> String {
        return "Flips: \(String(gameStats.flipCount))"
    }

    func incrementFlipCount() {
        gameStats.incrementFlipCount();

        updateCurrentCardTitle()
    }

    func updateCurrentCardTitle() {
        if gameStats.flipCount % 2 == 0 && !deck.isEmpty {
            if let title = deck.drawACard()?.description {
                currentCardTitle = title
            }
        }
    }
}