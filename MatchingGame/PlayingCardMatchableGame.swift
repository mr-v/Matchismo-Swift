//
//  PlayingCardMatchableGame.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 08/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class PlayingCardMatchableGame: Matchable {
    private var cards: [PlayingCard]
    private var rewardConfiguration: PlayingCardRewardPointConfiguration
    private(set) var numberOfCards: Int

    init(numberOfCards: Int, rewardConfiguration: PlayingCardRewardPointConfiguration, deck d: Deck = Deck() ) {
        cards = []
        self.rewardConfiguration = rewardConfiguration
        self.numberOfCards = numberOfCards
        var deck = d
        numberOfCards.times {
            if deck.isEmpty {
                deck = Deck()
            }
            self.cards.append(deck.drawACard())
        }
    }

    func match(numberOfCardsToMatch:Int, chosenCardsIndexes: [Int]) -> (success: Bool, points: Int) {
        // allow partial matching
        var currentlyChosen: [PlayingCard] = chosenCardsIndexes.map{ self.cards[$0] }
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
            reward = rewardConfiguration.rankReward

        case let (s, _) where s == numberOfCardsToMatch:
            reward = rewardConfiguration.suitReward

        case let (_, r) where r == numberOfCardsToMatch - 1 && !ignorePartialMatches:
            reward = rewardConfiguration.rankReward

        case let (s, _) where s == numberOfCardsToMatch - 1 && !ignorePartialMatches:
            reward = rewardConfiguration.suitReward
        default:
            return (false, 0)
        }

        let difficultyBonus = 4 * (numberOfCardsToMatch - 2)/2
        return (true, reward! + difficultyBonus)
    }


    func redeal() {

    }

    func printableForCardWithNumber(number: Int) -> Printable {
        return cards[number]
    }

    private func rewardPartialMatch(originalReward: Int) -> Int {
        return Int(Double(originalReward) * rewardConfiguration.partialMatchMultiplier)
    }

}
