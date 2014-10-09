//
//  TestFactory.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 08/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

// MARK: - game
let threeSuitMatchingCards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Three), PlayingCard(suit: .Hearts, rank: .Four)]
let twoRankMatchingCards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Two)]
let threeMismatchedCards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Three), PlayingCard(suit: .Diamonds, rank: .Four)]

func makeGameWithFirstThreeCardsMatchingWithSuits() -> MatchingGame {
    return makePlayingCardMatchingGameWithStubDeck(cards: threeSuitMatchingCards)
}

func makeGameWithFirstTwoCardsMatchingWithRanks() -> MatchingGame {
    return makePlayingCardMatchingGameWithStubDeck(cards: twoRankMatchingCards)
}

func makeGameWithFirstThreeMismatchedCards() -> MatchingGame {
    return makePlayingCardMatchingGameWithStubDeck(cards: threeMismatchedCards)
}

func makeGameWithCard(card: PlayingCard) -> MatchingGame {
    return makePlayingCardMatchingGameWithStubDeck(cards: [card])
}

func makePlayingCardMatchingGameWithStubDeck(cards c: [PlayingCard], cardCount: Int = 12) -> MatchingGame {
    let stubDeck = makeStubDeck(cards: c)
    return makePlayingCardMatchingGame(cardCount: cardCount, numberOfcardsToMatch: 2, deck: stubDeck)
}

private func makeStubDeck(cards c: [PlayingCard]) -> Deck {
    return InfiniteStubDeck(cards: c)
}

private class InfiniteStubDeck: Deck {
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

func makePlayingCardMatchingGame(cardCount: Int = 12, numberOfcardsToMatch: Int = 2, deck: Deck = Deck()) -> MatchingGame {
    let playingCardMatcher = PlayingCardMatcher(numberOfCards: cardCount, rewardConfiguration: makePlayingCardRewardPointConfiguration(), deck: deck)

    return MatchingGame(matcher: playingCardMatcher, configuration: makePenaltyPointConfiguration(), numberOfCardsToMatch: numberOfcardsToMatch)
}

func makePlayingCardMatcher(cards: [PlayingCard]) -> PlayingCardMatcher {
    return PlayingCardMatcher(numberOfCards: 12, rewardConfiguration: makePlayingCardRewardPointConfiguration(), deck: makeStubDeck(cards: cards))
}

func makeGameViewModelWithPlayingCardsGame() -> GameViewModel  {
    return  makeGameViewModelWithPlayingCardsGame([])
}

func makeGameViewModelWithPlayingCardsGame(cards: [PlayingCard]) -> GameViewModel  {
    let matchPoints = PenaltyPointConfiguration(choosePenalty: choosePenalty, mismatchPenalty: mismatchPenalty)
    let playingCardGamePoints = PlayingCardRewardPointConfiguration(suitReward: suitReward, rankReward: rankReward, partialMatchMultiplier: partialMatchMultiplier)
    let deck = !cards.isEmpty ? makeStubDeck(cards: cards) : Deck()
    let playingCardMatcher = PlayingCardMatcher(numberOfCards: 30, rewardConfiguration: playingCardGamePoints, deck: deck)
    let game = MatchingGame(matcher: playingCardMatcher, configuration: matchPoints, numberOfCardsToMatch: 2)
    return GameViewModel(game: game, printer: PlayingCardSymbolPrinter(matchable: playingCardMatcher))
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
