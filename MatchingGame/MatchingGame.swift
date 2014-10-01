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
    internal private(set) var score: Int
    private(set) var cards: [PlayingCard]
    internal let pointsConfiguration: PointsConfiguration
    private var lastPickedCardIndex: Int?
    var matchedCardsIndexes: [Int: Bool]    // leave as internal - will be visible to ViewModels but hidden from application using the framework
    var numberOfCards: Int {
        get { return cards.count }
    }
    var numberOfCardsToMatch: Int {
        didSet {
            let cardWasPicked = matchedCardsIndexes.isEmpty && lastPickedCardIndex? == nil
            if !cardWasPicked {
                numberOfCardsToMatch = oldValue
            }
        }
    }
    
    init(configuration: PointsConfiguration, numberOfCards: Int, numberOfCardsToMatch: Int = 2, deck d: Deck = Deck()) {
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
        self.numberOfCardsToMatch = numberOfCardsToMatch
    }

    func chooseCardWithNumber(number: Int) {
        var newPick: PlayingCard = cards[number]
        if matchedCardsIndexes[number] != nil {
            return
        }

        newPick.flip()
        if newPick.chosen {
            score -= pointsConfiguration.choosePenalty
        }

        var oldPick: PlayingCard?
        if let i = lastPickedCardIndex? {
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
                score -= pointsConfiguration.mismatchPenalty
                oldPick!.flip()
                cards[lastPickedCardIndex!] = oldPick!
            default:
                score += 0       // compiler made me do it
            }
        }

        if rewardApplied {
            matchedCardsIndexes[lastPickedCardIndex!] = true
            matchedCardsIndexes[number] = true
            lastPickedCardIndex = nil
        } else {
            lastPickedCardIndex = number
        }
        cards[number] = newPick
    }

    func cardWithNumber(number: Int) -> PlayingCard {
        return cards[number]
    }
}
