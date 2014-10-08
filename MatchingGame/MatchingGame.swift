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

protocol Matchable {
    func match() -> (success: Bool, points: Int)
}

class MatchingGame: Matchable {
//    private matcher: Matchable
    internal private(set) var score: Int
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
    internal let pointsConfiguration: PointsConfiguration
    var chosenCardsIndexes: [Int: Bool]
    var matchedCardsIndexes: [Int: Bool]    // leave as internal - will be visible to ViewModels but hidden from application if wrapped up in a framework
    private var cards: [PlayingCard]

    init(configuration: PointsConfiguration, numberOfCardsToMatch: Int) {
        score = 0
        cards = []

        chosenCardsIndexes =  [Int: Bool]()
        matchedCardsIndexes = [Int: Bool]()
        pointsConfiguration = configuration
        self.numberOfCardsToMatch = numberOfCardsToMatch
    }

    func chooseCardWithNumber(number: Int) {
        if isCardMatched(number) {
            return
        }

        flipCard(number)
        if !isCardChosen(number) {
            chosenCardsIndexes.removeValueForKey(number)
            return
        }

        score += pointsConfiguration.choosePenalty
        chosenCardsIndexes[number] = true

        let enoughCardsToCheckMatch = chosenCardsIndexes.count == numberOfCardsToMatch
        if !enoughCardsToCheckMatch {
            return
        }

        let (success, points) = match()
        if success {
            score += points
            for (number, _) in chosenCardsIndexes {
                matchedCardsIndexes[number] = true
            }
            chosenCardsIndexes.removeAll(keepCapacity: true)
        } else {
            score += pointsConfiguration.mismatchPenalty
            chosenCardsIndexes.removeAll(keepCapacity: true)
            chosenCardsIndexes[number] = true
        }
    }

    func isCardChosen(number: Int) -> Bool {
        return chosenCardsIndexes[number] != nil
    }

    func isCardMatched(number: Int) -> Bool {
        return matchedCardsIndexes[number] != nil
    }

    func flipCard(number: Int) {
        if isCardChosen(number) {
            chosenCardsIndexes.removeValueForKey(number)
        } else {
            chosenCardsIndexes[number] = true
        }
    }


    // MARK: - to be delegated
    func printableForCardWithNumber(number: Int) -> Printable {
        return cards[number]
    }

    func match() -> (success: Bool, points: Int) {
        return (true, 0)
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

    override func match() -> (Bool, Int) {
        // allow partial matching
        var currentlyChosen: [PlayingCard] = chosenCardsIndexes.keys.array.map{ self.cards[$0] }
        var rankMatches = [Rank: Int]()
        var suitMatches = [Suit: Int]()
        for card in currentlyChosen {
            rankMatches[card.rank] = rankMatches[card.rank]?.advancedBy(1) ?? 1
            suitMatches[card.suit] = suitMatches[card.suit]?.advancedBy(1) ?? 1
        }
        let rankMatchesMax = maxElement(rankMatches.values)
        let suitMatchesMax = maxElement(suitMatches.values)
        let ignorePartialMatches = numberOfCardsToMatch < 3
        var reward: Int?
        switch (suitMatchesMax, rankMatchesMax) {
        case let (_, r) where r == numberOfCardsToMatch:
            reward = rewardMatchWithBonus(pointsConfiguration.rankMatchReward)

        case let (s, _) where s == numberOfCardsToMatch:
            reward = rewardMatchWithBonus(pointsConfiguration.suitMatchReward)

        case let (_, r) where r == numberOfCardsToMatch - 1 && !ignorePartialMatches:
            reward = rewardPartialMatch(pointsConfiguration.rankMatchReward)

        case let (s, _) where s == numberOfCardsToMatch - 1 && !ignorePartialMatches:
            reward = rewardPartialMatch(pointsConfiguration.suitMatchReward)
        default:
            return (false, 0)
        }

        return (true, reward!)
    }

    func rewardPartialMatch(originalReward: Int) -> Int {
        let reward = Int(Double(originalReward) * pointsConfiguration.partialMatchMultiplier)
        return rewardMatchWithBonus(reward)
    }

    func rewardMatchWithBonus(reward: Int) -> Int {
        return reward + difficultyBonus()
    }

    func difficultyBonus() -> Int {
        return 4 * (numberOfCardsToMatch - 2)/2
    }
}
