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
    private var matchedCardsIndexes: [Int: Bool]

    init(configuration: PointsConfiguration, numberOfCards: Int, deck d: Deck = Deck()) {
        cards = []
        matchedCardsIndexes = [Int: Bool]()
        var deck = d
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
        if matchedCardsIndexes[number] != nil {
            return
        }

        newPick.flip()
        if newPick.chosen {
            score -= pointsConfiguration.choosePenalty
        }

        var oldPick: PlayingCard?
        if let i = pickedCardIndex? {
            oldPick = cards[i]
        }

        let eligibleForMatching = (newPick.chosen == oldPick?.chosen) && newPick.chosen
        var rewardApplied = false
        if eligibleForMatching {
            let matching = (ranks: newPick.rank == oldPick!.rank, suits: newPick.suit == oldPick!.suit)
            switch matching {
            case let (true, _):
                score += pointsConfiguration.rankMatchReward
                rewardApplied = true
            case let (false, true):
                score += pointsConfiguration.suitMatchReward
                rewardApplied = true
            case let (false, false):
                score += pointsConfiguration.mismatchPenalty
            default:
                score += 0       // compiler made me do it
            }
        }

        if rewardApplied {
            matchedCardsIndexes[pickedCardIndex!] = true
            matchedCardsIndexes[number] = true
            pickedCardIndex = nil
        } else {
            pickedCardIndex = number
            cards[pickedCardIndex!] = newPick
        }
    }
}

// MARK: test extension

extension MatchingGame  {
    func numberOfCads() -> Int {
        return cards.count
    }
}
