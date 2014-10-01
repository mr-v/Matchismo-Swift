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
    internal private(set) var currentlyChosenCardIndexes: [Int]
    var matchedCardsIndexes: [Int: Bool]    // leave as internal - will be visible to ViewModels but hidden from application using the framework
    var numberOfCards: Int {
        get { return cards.count }
    }
    var numberOfCardsToMatch: Int {
        didSet {
            let cardWasPicked = matchedCardsIndexes.isEmpty && currentlyChosenCardIndexes.isEmpty
            if !cardWasPicked {
                numberOfCardsToMatch = oldValue
            }
        }
    }
    
    init(configuration: PointsConfiguration, numberOfCards: Int, numberOfCardsToMatch: Int = 2, deck d: Deck = Deck()) {
        cards = []
        currentlyChosenCardIndexes = [Int]()
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
        let alreadyMatched = matchedCardsIndexes[number] != nil
        if alreadyMatched {
            return
        }

        var newPick: PlayingCard = cards[number]
        newPick.flip()
        cards[number] = newPick
        if !newPick.chosen {
            return
        }

        score -= pointsConfiguration.choosePenalty

        if !contains(currentlyChosenCardIndexes, number) {
            currentlyChosenCardIndexes.append(number)
        }

        let enoughCardsToCheckMatch = currentlyChosenCardIndexes.count == numberOfCardsToMatch
        if !enoughCardsToCheckMatch {
            return
        }

        var oldPicks: [PlayingCard] = currentlyChosenCardIndexes.map{ self.cards[$0] }
        // rules match stricly 3, mismatch otherwise
        var matches: (suitMatches: Int, rankMaches: Int) = (0, 0)
        for card in oldPicks {
            if card.suit == newPick.suit {
                matches.suitMatches++
            }
            if card.rank == newPick.rank {
                matches.rankMaches++
            }
        }

        switch matches {
        case (_, numberOfCardsToMatch):
            rewardMatch(pointsConfiguration.rankMatchReward)
        case (numberOfCardsToMatch, _):
            rewardMatch(pointsConfiguration.suitMatchReward)
        default:
            score -= pointsConfiguration.mismatchPenalty
            for i in currentlyChosenCardIndexes {
                var c = cards[i]
                c.flip()
                cards[i] = c
            }
            currentlyChosenCardIndexes = [number]
        }
    }

    func rewardMatch(reward: Int) {
        score += reward
        for i in currentlyChosenCardIndexes {
            matchedCardsIndexes[i] = true
        }
        currentlyChosenCardIndexes.removeAll(keepCapacity: true)
    }

    func cardWithNumber(number: Int) -> PlayingCard {
        return cards[number]
    }
}
