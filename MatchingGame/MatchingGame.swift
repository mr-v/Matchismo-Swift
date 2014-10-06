//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 06/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

struct PointsConfiguration {
    let choosePenalty: Int
    let suitMatchReward: Int
    let rankMatchReward: Int
    let mismatchPenalty: Int
    let partialMatchMultiplier: Double
}

// ChoosePointsConfiguration

class MatchingGame {
    internal private(set) var score: Int
    private var cards: [PlayingCard]
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

    init(configuration: PointsConfiguration, numberOfCardsToMatch: Int) {
        score = 0
        cards = []
        currentlyChosenCardIndexes = [Int]()
        matchedCardsIndexes = [Int: Bool]()
        pointsConfiguration = configuration
        self.numberOfCardsToMatch = numberOfCardsToMatch
    }

    func match() -> Bool {
        fatalError("need to implement \"match\" methond in a \(self.self)")
    }

    func mismatch() {
        fatalError("need to implement \"mismatch\" methond in a \(self.self)")
    }
}

class PlayingCardMatchingGame : MatchingGame {

    init(configuration: PointsConfiguration, numberOfCards: Int, numberOfCardsToMatch: Int = 2, deck d: Deck = Deck()) {
        super.init(configuration: configuration, numberOfCardsToMatch: numberOfCardsToMatch)

        var deck = d
        numberOfCards.times {
            if deck.isEmpty {
                deck = Deck()
            }
            self.cards.append(deck.drawACard())
        }
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
            for var i = 0; i < currentlyChosenCardIndexes.count; i++ {
                if currentlyChosenCardIndexes[i] == number {
                    currentlyChosenCardIndexes.removeAtIndex(i)
                    break
                }
            }
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

        let success = match()
        if !success {
            mismatch()
            currentlyChosenCardIndexes = [number]
        }
    }

    override func match() -> Bool {
        // allow partial matching
        var currentlyChosen: [PlayingCard] = currentlyChosenCardIndexes.map{ self.cards[$0] }
        var rankMatches = [Rank: Int]()
        var suitMatches = [Suit: Int]()
        for cards in currentlyChosen {
            rankMatches[cards.rank] = rankMatches[cards.rank]?.advancedBy(1) ?? 1
            suitMatches[cards.suit] = suitMatches[cards.suit]?.advancedBy(1) ?? 1
        }
        let rankMatchesMax = maxElement(rankMatches.values)
        let suitMatchesMax = maxElement(suitMatches.values)
        let ignorePartialMatches = numberOfCardsToMatch < 3
        switch (suitMatchesMax, rankMatchesMax) {
        case let (_, r) where r == numberOfCardsToMatch:
            rewardMatchWithBonus(pointsConfiguration.rankMatchReward)

        case let (s, _) where s == numberOfCardsToMatch:
            rewardMatchWithBonus(pointsConfiguration.suitMatchReward)

        case let (_, r) where r == numberOfCardsToMatch - 1 && !ignorePartialMatches:
            rewardPartialMatch(pointsConfiguration.rankMatchReward)

        case let (s, _) where s == numberOfCardsToMatch - 1 && !ignorePartialMatches:
            rewardPartialMatch(pointsConfiguration.suitMatchReward)
        default:
            return false
        }


        return true
    }

    override func mismatch() {
        score -= pointsConfiguration.mismatchPenalty
        let previousPickIndex = currentlyChosenCardIndexes.count - 2
        for var i = previousPickIndex; i >= 0; i-- {
            let index = currentlyChosenCardIndexes[i]
            var c = cards[index]
            c.flip()
            cards[index] = c
        }
    }

    func rewardPartialMatch(originalReward: Int) {
        let reward = Int(Double(originalReward) * pointsConfiguration.partialMatchMultiplier)
        rewardMatchWithBonus(reward)
    }

    func rewardMatchWithBonus(reward: Int) {
        rewardMatch(reward + difficultyBonus())
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

    func difficultyBonus() -> Int {
        return 4 * (numberOfCardsToMatch - 2)/2
    }
}
