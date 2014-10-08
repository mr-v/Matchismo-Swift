//
//  TestFactory.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 08/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

// MARK: - game

func makeGameWithFirstThreeCardsMatchingWithSuits() -> MatchingGame {
    let matchingSuits = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Three), PlayingCard(suit: .Hearts, rank: .Four)]
    return makePlayingCardMatchingGameWithStubDeck(cards: matchingSuits)
}

func makeGameWithFirstTwoCardsMatchingWithRanks() -> MatchingGame {
    let cards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Two)]
    return makePlayingCardMatchingGameWithStubDeck(cards: cards)
}

func makeGameWithFirstThreeMismatchedCards() -> MatchingGame {
    let mismatched = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Three), PlayingCard(suit: .Diamonds, rank: .Four)]
    return makePlayingCardMatchingGameWithStubDeck(cards: mismatched)
}

func makeGameWithCard(card: PlayingCard) -> MatchingGame {
    return makePlayingCardMatchingGameWithStubDeck(cards: [card])
}

func makePlayingCardMatchingGameWithStubDeck(cards c: [PlayingCard], cardCount: Int = 12) -> MatchingGame {
    class InfiniteStubDeck: Deck {
        override var isEmpty: Bool {
            get {
                return false
            }
        }
        let stubCards: [PlayingCard]
        var index: Int = 0

        init(cards: [PlayingCard]) {
            stubCards = cards
        }

        override func drawACard() -> PlayingCard! {
            let card = stubCards[index]
            ++index
            index %= stubCards.count
            return card
        }
    }
    let stubDeck = InfiniteStubDeck(cards: c)

    return makePlayingCardMatchingGame(cardCount: cardCount, numberOfcardsToMatch: 2, deck: stubDeck)
}

func makePlayingCardMatchingGame(cardCount: Int = 12, numberOfcardsToMatch: Int = 2, deck: Deck = Deck()) -> MatchingGame {

    let playingCardMatcher = PlayingCardMatchableGame(numberOfCards: cardCount, rewardConfiguration: makePlayingCardRewardPointConfiguration(), deck: deck)

    return MatchingGame(matcher: playingCardMatcher, configuration: makePenaltyPointConfiguration(), numberOfCardsToMatch: numberOfcardsToMatch)
}

// MARK: - points

let choosePenalty = -1
let mismatchPenalty = -2
let suitReward = 4
let rankReward = 16
let partialMatchMultiplier = 0.5

func makePenaltyPointConfiguration() -> PenaltyPointConfiguration {
    return PenaltyPointConfiguration(choosePenalty: choosePenalty, mismatchPenalty: mismatchPenalty)
}

func makePlayingCardRewardPointConfiguration() -> PlayingCardRewardPointConfiguration {
    return PlayingCardRewardPointConfiguration(suitReward: suitReward, rankReward: rankReward, partialMatchMultiplier: partialMatchMultiplier)
}
