//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 28/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

struct PointsConfiguration {
    let choosePenalty: Int
    let suitMatchReward: Int
    let rankMatchReward: Int
    let mismatchPenalty: Int
}

class MatchingGame {
    private let pointsConfiguration: PointsConfiguration
    internal private(set) var score: Int
    private var pickedCardIndex: Int?
    private var cards: [PlayingCard]

    init(configuration: PointsConfiguration, numberOfCards: Int, deck d: Deck = Deck()) {
        var deck = d
        cards = []
        for _ in 1...numberOfCards {
            if deck.isEmpty {
                deck = Deck()
            }
            cards.append(deck.drawACard())
        }

        pointsConfiguration = configuration
        score = 0
    }

    func pickCardWithNumber(number: Int) {
        var newPick: PlayingCard = cards[number]
        newPick.flip()
        if newPick.chosen {
            score -= pointsConfiguration.choosePenalty
        }

        var oldPick: PlayingCard?
        if let i = pickedCardIndex? {
            oldPick = cards[i]
        }
        pickedCardIndex = number
        cards[pickedCardIndex!] = newPick

        let eligibleForMatching = (newPick.chosen == oldPick?.chosen) && newPick.chosen
        if eligibleForMatching {
            let matching = (ranks: newPick.rank == oldPick!.rank, suits: newPick.suit == oldPick!.suit)
            switch matching {
            case let (true, _):
                score += pointsConfiguration.rankMatchReward
            case let (false, true):
                score += pointsConfiguration.suitMatchReward
            case let (false, false):
                score += pointsConfiguration.mismatchPenalty
            default:
                score += 0       // compiler made me do it
            }
        }
    }
}

// MARK: test extension

extension MatchingGame  {
    func numberOfCads() -> Int {
        return cards.count
    }
}
