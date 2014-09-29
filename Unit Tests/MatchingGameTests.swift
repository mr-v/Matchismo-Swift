//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 28/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

class MatchingGameTests: XCTestCase {

    func test_MatchingGame_Created_ScoreIsZero() {
        let game = makeMatchingGame()

        let score = game.score

        XCTAssertEqual(score, 0, "")
    }

    func test_pickCardWithNumber_PickingUnchosenCard_AppliesPenalty() {
        let game = makeMatchingGame()

        let expected = game.score - makeGamePointsConfiguration().choosePenalty
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
        let game = makeMatchingGame()

        let expected = game.score - makeGamePointsConfiguration().choosePenalty
        for _ in 1...2 { game.pickCardWithNumber(0)}

        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_pickCardWithNumber_EarlierChosenMismatchedCard_GetsFlipped() {

    }

    func test_pickCardWithNumber_PickingMatchingSuits_AppliesReward() {
        let game = makeGameWithFirstTwoCardsMatchingWithSuits()
        let points = makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.suitMatchReward
        game.pickCardWithNumber(0)
        game.pickCardWithNumber(1)
        let newScore = game.score
        
        XCTAssertEqual(newScore, expected, "")
    }

    func test_pickCardWithNumber_PickingMatchingRanks_AppliesReward() {
        let game = makeGameWithFirstTwoCardsMatchingWithRanks()
        let points = makeGamePointsConfiguration()
        let expected = game.score - points.choosePenalty * 2 + points.rankMatchReward

        game.pickCardWithNumber(0)
        game.pickCardWithNumber(1)
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_pickCardWithNumber_PickingMismatchedCards_AppliesPenalty() {
        let game = makeGameWithFirstTwoMismatchedCards()
        let points = makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.mismatchPenalty
        game.pickCardWithNumber(0)
        game.pickCardWithNumber(1)
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_pickCardWithNumber_MatchedCards_AreInactiveDontChangeTheScore() {
        let game = makeGameWithFirstTwoCardsMatchingWithSuits()
        func flipBothCardsTwoTimes() {
            for _ in 1...2 {
                game.pickCardWithNumber(0)
                game.pickCardWithNumber(1)
            }
        }

        game.pickCardWithNumber(0)
        game.pickCardWithNumber(1)
        let expected = game.score
        flipBothCardsTwoTimes()
        let result = game.score

        XCTAssertEqual(result, expected, "")
    }

    func test_pickedCardWithNumber_MismatchedCard_IsAvailableForPicking() {
        let game = makeGameWithFirstTwoMismatchedCards()
        let points = makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.suitMatchReward
        game.pickCardWithNumber(0)
        game.pickCardWithNumber(1)
        let earlierScore = game.score
        for _ in 1...2 { game.pickCardWithNumber(1) }
        let result = game.score

        XCTAssertNotEqual(result, earlierScore, "")
    }


    // MARK:

    func makeGameWithFirstTwoCardsMatchingWithSuits() -> MatchingGame {
        let matchingSuits = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Three)]
        return makeMatchingGameWithStubDeck(cards: matchingSuits)
    }

    func makeGameWithFirstTwoCardsMatchingWithRanks() -> MatchingGame {
        let cards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Two)]
        return makeMatchingGameWithStubDeck(cards: cards)
    }

    func makeGameWithFirstTwoMismatchedCards() -> MatchingGame {
        let mismatched = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Three)]
        return makeMatchingGameWithStubDeck(cards: mismatched)
    }

    func makeMatchingGame(cardCount: Int = 12) -> MatchingGame {
        return MatchingGame(configuration: makeGamePointsConfiguration(), numberOfCards: cardCount)
    }

    func makeMatchingGameWithStubDeck(cards c: [PlayingCard], cardCount: Int = 12) -> MatchingGame {
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

        return MatchingGame(configuration: makeGamePointsConfiguration(), numberOfCards: cardCount, deck: stubDeck)
    }

    func makeGamePointsConfiguration() -> PointsConfiguration {
        return PointsConfiguration(choosePenalty: 1, suitMatchReward: 4, rankMatchReward: 16, mismatchPenalty: 2)
    }
}
