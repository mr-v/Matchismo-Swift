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

    func test_chooseCardWithNumber_PickingMatchingSuits_AppliesReward() {
        let game = TestGameFactory().makeGameWithFirstThreeCardsMatchingWithSuits()
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
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        let points = TestGameFactory().makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 - points.mismatchPenalty
        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_MatchedCards_AreInactiveDontChangeTheScore() {
        let game = TestGameFactory().makeGameWithFirstThreeCardsMatchingWithSuits()
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
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        let points = TestGameFactory().makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.suitMatchReward
        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)
        let earlierScore = game.score
        for _ in 1...2 { game.chooseCardWithNumber(1) }
        let result = game.score

        XCTAssertNotEqual(result, earlierScore, "")
    }

    func test_pickedCardWithNumber_PickingSameCardTwoTimesInTheRow_AppliesPenaltyTwice() {
        let game = TestGameFactory().makeMatchingGame()
        func chooseWithPenaltyTwoTimes() {
            for _ in 1...3 {
                game.chooseCardWithNumber(0)
            }
        }
        let expected = game.score - 2 * TestGameFactory().makeGamePointsConfiguration().choosePenalty
        chooseWithPenaltyTwoTimes()
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

    // MARK: - Matching multiple cards (3+)

    func test_matchedCardNumbers_MatchingAgainstThreeCards_IndexesOfCardsThatWereMatched() {
        let game = TestGameFactory().makeGameWithFirstThreeCardsMatchingWithSuits()
        let points = TestGameFactory().makeGamePointsConfiguration()
        game.numberOfCardsToMatch = 3

        let expected = [0, 1, 2]
        for i in expected { game.chooseCardWithNumber(i) }

        var matchedNumbers = game.matchedCardsIndexes.keys.array
        matchedNumbers.sort(<)
        XCTAssertEqual(matchedNumbers, expected, "")
    }

// picking two times - no penalty

    func test_chooseCardWithNumber_PickingThreeMatchingSuits_AppliesReward() {
        let game = TestGameFactory().makeGameWithFirstThreeCardsMatchingWithSuits()
        game.numberOfCardsToMatch = 3
        let points = TestGameFactory().makeGamePointsConfiguration()
        let expected = game.score - points.choosePenalty * 3 + points.suitMatchReward
        for i in 0...2 { game.chooseCardWithNumber(i) }

        let newScore = game.score
        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_AppliesPenalty() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        let points = TestGameFactory().makeGamePointsConfiguration()
        let cardsToMatch = 3
        game.numberOfCardsToMatch = cardsToMatch
        let range = 0..<cardsToMatch

        let expected = game.score - points.choosePenalty * cardsToMatch - points.mismatchPenalty
        for i in range { game.chooseCardWithNumber(i) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_FirstTwoCardsAreAvailableToChose() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()

        for i in 0...2 { game.chooseCardWithNumber(i) }

        let currentlyChosen = game.currentlyChosenCardIndexes
        let cardsAreAvailable = !contains(currentlyChosen, 0) && !contains(currentlyChosen, 1)
        XCTAssertTrue(cardsAreAvailable, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_FirstCardIsNotChosen() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        game.numberOfCardsToMatch = 3

        for i in 0...2 { game.chooseCardWithNumber(i) }

        let chosen = game.cards[0].chosen
        XCTAssertFalse(chosen, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_SecondCardIsNotChosen() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        game.numberOfCardsToMatch = 3

        for i in 0...2 { game.chooseCardWithNumber(i) }

        let chosen = game.cards[1].chosen
        XCTAssertFalse(chosen, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_LastCardIsNotAvailableToChose() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()

        for i in 0...2 { game.chooseCardWithNumber(i) }

        let cardIsChosen = game.cards[2].chosen
        XCTAssertTrue(cardIsChosen, "")
    }

    func test_chooseCardWithNumber_PickingThreeMatchingRanks_AppliesReward() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()
        let points = TestGameFactory().makeGamePointsConfiguration()
        let expected = game.score - points.choosePenalty * 3 + points.rankMatchReward
        for i in 0...2 { game.chooseCardWithNumber(i) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_FullyFlippingCardAndFlippingOtherMatchingCardOnce_DoesntProduceAMatch() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()

        game.chooseCardWithNumber(1)
        game.chooseCardWithNumber(1)
        game.chooseCardWithNumber(0)

        let expected = game.matchedCardsIndexes.isEmpty
        XCTAssertTrue(expected, "")
    }

    func test_chooseCardWithNumber_FullyFlippingCard_ClearsCurrenltyChosenIndexes() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()

        game.chooseCardWithNumber(1)
        game.chooseCardWithNumber(1)

        let noChosenIndexes = game.currentlyChosenCardIndexes.isEmpty
        XCTAssertTrue(noChosenIndexes, "")
    }

    func test_chooseCardWithNumber_TwoCardsOutOfThreeMatchWithSuit_AppliesRewardForPartialMatch() {
        let cardsWithTwoMachingSuits = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Three)]
        let game = TestGameFactory().makeMatchingGameWithStubDeck(cards: cardsWithTwoMachingSuits)
        let matchCount = 3
        game.numberOfCardsToMatch = matchCount
        let points = TestGameFactory().makeGamePointsConfiguration()
        let expectedScore = game.score - points.choosePenalty * matchCount + Int(points.partialMatchMultiplier * Double(points.suitMatchReward))

        for i in 0...2 { game.chooseCardWithNumber(i) }

        let currentScore = game.score
        XCTAssertEqual(currentScore, expectedScore, "")
    }
}

class TestGameFactory {
    func makeGameWithFirstThreeCardsMatchingWithSuits() -> MatchingGame {
        let matchingSuits = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Three), PlayingCard(suit: .Hearts, rank: .Four)]
        return makeMatchingGameWithStubDeck(cards: matchingSuits)
    }

    func makeGameWithFirstTwoCardsMatchingWithRanks() -> MatchingGame {
        let cards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Two)]
        return makeMatchingGameWithStubDeck(cards: cards)
    }

    func makeGameWithFirstThreeMismatchedCards() -> MatchingGame {
        let mismatched = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Three), PlayingCard(suit: .Diamonds, rank: .Four)]
        return makeMatchingGameWithStubDeck(cards: mismatched)
    }

    func makeGameWithCard(card: PlayingCard) -> MatchingGame {
        return makeMatchingGameWithStubDeck(cards: [card])
    }

    func makeMatchingGame(cardCount: Int = 12, numberOfcardsToMatch: Int = 2) -> MatchingGame {
        return MatchingGame(configuration: makeGamePointsConfiguration(), numberOfCards: cardCount, numberOfCardsToMatch: numberOfcardsToMatch)
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
        return PointsConfiguration(choosePenalty: 1, suitMatchReward: 4, rankMatchReward: 16, mismatchPenalty: 2, partialMatchMultiplier: 0.5)
    }
}
