//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 28/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class MatchingGameTests: XCTestCase {

    func test_MatchingGame_Created_ScoreIsZero() {
        let game = makeMatchingGame()

        let score = game.score

        XCTAssertEqual(score, 0, "")
    }

    func test_pickCardWithNumber_PickingUnchosenCard_AppliesPenalty() {
        let points = makeGamePointsConfiguration()
        let game = makeMatchingGame()

        let expected = game.score - points.choosePenalty
        game.pickCardWithNumber(0)
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_MatchingGame_Created_WithProperNumberOfCards() {
        let numberOfCardsToCreate = 60
        let game = makeMatchingGame(cardCount: numberOfCardsToCreate)

        let numberOfCards = game.numberOfCads()

        XCTAssertEqual(numberOfCards, numberOfCardsToCreate, "")
    }

    func test_pickCardWithNumber_PickingChosenCard_AppliesNoPenalty() {
        let points = makeGamePointsConfiguration()
        let game = makeMatchingGame()

        let expected = game.score - makeGamePointsConfiguration().choosePenalty
        for _ in 1...2 {
            game.pickCardWithNumber(0)
        }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_pickCardWithNumber_PickingMatchingSuits_AppliesReward() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Three)]
        let game = makeMatchingGameWithStubDeck(cards: cards)
        let points = makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.suitMatchReward
        game.pickCardWithNumber(0)
        game.pickCardWithNumber(1)
        let result = game.score

        
        XCTAssertEqual(result, expected, "")
    }

    func test_pickCardWithNumber_PickingMatchingRanks_AppliesReward() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Two)]
        let game = makeMatchingGameWithStubDeck(cards: cards)
        let points = makeGamePointsConfiguration()
        let expected = game.score - points.choosePenalty * 2 + points.rankMatchReward

        game.pickCardWithNumber(0)
        game.pickCardWithNumber(cards.count)
        let result = game.score

        XCTAssertEqual(result, expected, "")
    }

    func test_pickCardWithNumber_PickingMismatchedCards_AppliesPenalty() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Three)]
        let game = makeMatchingGameWithStubDeck(cards: cards)
        let points = makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.mismatchPenalty
        game.pickCardWithNumber(0)
        game.pickCardWithNumber(1)
        let result = game.score


        XCTAssertEqual(result, expected, "")
    }

    // MARK:

    func makeMatchingGame(cardCount: Int = 12) -> MatchingGame {
        return MatchingGame(configuration: makeGamePointsConfiguration(), numberOfCards: cardCount)
    }

    func makeMatchingGameWithStubDeck(cards c: [PlayingCard], cardCount: Int = 12) -> MatchingGame {
        class StubDeck: Deck {
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
        let stubDeck = StubDeck(cards: c)

        return MatchingGame(configuration: makeGamePointsConfiguration(), numberOfCards: cardCount, deck: stubDeck)
    }

    func makeGamePointsConfiguration() -> PointsConfiguration {
        return PointsConfiguration(choosePenalty: 1, suitMatchReward: 4, rankMatchReward: 16, mismatchPenalty: 2)
    }
}
