//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 28/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

class MatchingGameTests: XCTestCase {

    func test_MatchingGame_AfterInitialization_ScoreIsZero() {
        let game = TestGameFactory().makeMatchingGame()

        let score = game.score

        XCTAssertEqual(score, 0, "")
    }

    func test_chooseCardWithNumber_PickingUnchosenCard_AppliesPenalty() {
        let game = TestGameFactory().makeMatchingGame()

        let expected = game.score - TestGameFactory().makeGamePointsConfiguration().choosePenalty
        game.chooseCardWithNumber(0)
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_MatchingGame_Initializes_WithProperNumberOfCards() {
        let numberOfCardsToCreate = 60
        let game = TestGameFactory().makeMatchingGame(cardCount: numberOfCardsToCreate)

        let numberOfCards = game.numberOfCards

        XCTAssertEqual(numberOfCards, numberOfCardsToCreate, "")
    }

    func test_chooseCardWithNumber_PickingChosenCard_AppliesNoPenalty() {
        let game = TestGameFactory().makeMatchingGame()

        let expected = game.score - TestGameFactory().makeGamePointsConfiguration().choosePenalty
        for _ in 1...2 { game.chooseCardWithNumber(0)}

        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

//    func test_currentlyChosenCardNumbers_AfterMismatch_FirstChosenMismatchedCardGetsFlipped()
//        {
//            let game = TestGameFactory().makeGameWithFirstTwoMismatchedCards()
//            let expected = [1]
//
//            game.chooseCardWithNumber(0)
//            game.chooseCardWithNumber(1)
//
//            let result = game.currentlyChosenCardNumbers
//            XCTAssertEqual(result, expected, "")
//    }

    func test_chooseCardWithNumber_PickingMatchingSuits_AppliesReward() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithSuits()
        let points = TestGameFactory().makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.suitMatchReward
        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)
        let newScore = game.score
        
        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingMatchingRanks_AppliesReward() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()
        let points = TestGameFactory().makeGamePointsConfiguration()
        let expected = game.score - points.choosePenalty * 2 + points.rankMatchReward

        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingMismatchedCards_AppliesPenalty() {
        let game = TestGameFactory().makeGameWithFirstTwoMismatchedCards()
        let points = TestGameFactory().makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 - points.mismatchPenalty
        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_MatchedCards_AreInactiveDontChangeTheScore() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithSuits()
        func flipBothCardsTwoTimes() {
            for _ in 1...2 {
                game.chooseCardWithNumber(0)
                game.chooseCardWithNumber(1)
            }
        }

        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)
        let expected = game.score
        flipBothCardsTwoTimes()
        let result = game.score

        XCTAssertEqual(result, expected, "")
    }

    func test_pickedCardWithNumber_MismatchedCard_IsAvailableForPicking() {
        let game = TestGameFactory().makeGameWithFirstTwoMismatchedCards()
        let points = TestGameFactory().makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.suitMatchReward
        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)
        let earlierScore = game.score
        for _ in 1...2 { game.chooseCardWithNumber(1) }
        let result = game.score

        XCTAssertNotEqual(result, earlierScore, "")
    }

    func test_pickedCardWithNumber_PickingSameCardTwoTimesInTheRow_AppliesProperPenelty() {
        let game = TestGameFactory().makeMatchingGame()
        func fullyFlipCardTwoTimes() {
            for _ in 1...3 {
                game.chooseCardWithNumber(0)
            }
        }
        let expected = game.score - 2 * TestGameFactory().makeGamePointsConfiguration().choosePenalty
        fullyFlipCardTwoTimes()
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_setNumberOfCardsToMatch_BeforeChoosingAnyCard_SetsProperly() {
        let game = TestGameFactory().makeMatchingGame()
        let needToMatch = game.numberOfCardsToMatch + 1
        game.numberOfCardsToMatch = needToMatch

        let result = game.numberOfCardsToMatch
        XCTAssertEqual(result, needToMatch, "")
    }

    func test_setNumberOfCardsToMatch_BeforeAnyCards_IgnoresNewSetting() {
        let game = TestGameFactory().makeMatchingGame()
        let needToMatch = game.numberOfCardsToMatch + 1
        game.chooseCardWithNumber(0)
        game.numberOfCardsToMatch = needToMatch

        let result = game.numberOfCardsToMatch
        XCTAssertNotEqual(result, needToMatch, "")
    }
}

class TestGameFactory {
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

    func makeGameWithCard(card: PlayingCard) -> MatchingGame {
        return makeMatchingGameWithStubDeck(cards: [card])
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

        return MatchingGame(configuration: makeGamePointsConfiguration(), numberOfCards: cardCount, numberOfCardsToMatch: 2, deck: stubDeck)
    }

    func makeGamePointsConfiguration() -> PointsConfiguration {
        return PointsConfiguration(choosePenalty: 1, suitMatchReward: 4, rankMatchReward: 16, mismatchPenalty: 2)
    }
}
