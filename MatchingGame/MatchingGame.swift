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
    var chosenCardsIndexes: [Int: Bool]
    var matchedCardsIndexes: [Int: Bool]    // leave as internal - will be visible to ViewModels but hidden from application if wrapped up in a framework
    var numberOfCards: Int {
        get { return cards.count }
    }
    var numberOfCardsToMatch: Int {
        didSet {
            let gameAlreadyStarted = matchedCardsIndexes.isEmpty && chosenCardsIndexes.isEmpty && score == 0
            if !gameAlreadyStarted {
                numberOfCardsToMatch = oldValue
            }
        }
    }

    init(configuration: PointsConfiguration, numberOfCardsToMatch: Int) {
        score = 0
        cards = []
        chosenCardsIndexes =  [Int: Bool]()
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

    func isCardChosen(number: Int) -> Bool {
        return chosenCardsIndexes[number] != nil
    }

    func flipCard(number: Int) {
        if isCardChosen(number) {
            chosenCardsIndexes.removeValueForKey(number)
        } else {
            chosenCardsIndexes[number] = true
        }
    }

    func chooseCardWithNumber(number: Int) {
        let alreadyMatched = matchedCardsIndexes[number] != nil
        if alreadyMatched {
            return
        }

        var newPick: PlayingCard = cards[number]
        flipCard(number)
        cards[number] = newPick
        if !isCardChosen(number) {
            chosenCardsIndexes.removeValueForKey(number)
            return
        }

        score -= pointsConfiguration.choosePenalty
        chosenCardsIndexes[number] = true

        let enoughCardsToCheckMatch = chosenCardsIndexes.count == numberOfCardsToMatch
        if !enoughCardsToCheckMatch {
            return
        }

        let success = match()
        if !success {
            mismatch()
            chosenCardsIndexes.removeAll(keepCapacity: true)
            chosenCardsIndexes[number] = true
        }
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

    override func match() -> Bool {
        // allow partial matching
        var currentlyChosen: [PlayingCard] = chosenCardsIndexes.keys.array.map{ self.cards[$0] }
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

        for (number, _) in chosenCardsIndexes {
            matchedCardsIndexes[number] = true
        }
        chosenCardsIndexes.removeAll(keepCapacity: true)
    }

    func cardWithNumber(number: Int) -> PlayingCard {
        return cards[number]
    }

    func difficultyBonus() -> Int {
        return 4 * (numberOfCardsToMatch - 2)/2
    }
}
