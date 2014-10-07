//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 28/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

class PlayingCardMatchingGameTests: XCTestCase {

    func test_PlayingCardMatchingGame_AfterInitialization_ScoreIsZero() {
        let game = TestGameFactory().makePlayingCardMatchingGame()

        let score = game.score

        XCTAssertEqual(score, 0, "")
    }

    func test_MatchingGame_Created_CardsNotChosenByDefault() {
        let game = TestGameFactory().makePlayingCardMatchingGame()

        var chosen = false
        game.numberOfCardsToMatch.times { chosen |= game.isCardChosen($0) }

        XCTAssertFalse(chosen, "")
    }

    func test_flipCard_ChangesChosen() {
        let game = TestGameFactory().makePlayingCardMatchingGame()

        game.flipCard(0)

        var chosen = game.isCardChosen(0)
        XCTAssertTrue(chosen, "")
    }

    func test_chooseCardWithNumber_PickingUnchosenCard_AppliesPenalty() {
        let game = TestGameFactory().makePlayingCardMatchingGame()

        let expected = game.score - TestGameFactory().makeGamePointsConfiguration().choosePenalty
        game.chooseCardWithNumber(0)
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_PlayingCardMatchingGame_Initializes_WithProperNumberOfCards() {
        let numberOfCardsToCreate = 60
        let game = TestGameFactory().makePlayingCardMatchingGame(cardCount: numberOfCardsToCreate)

        let numberOfCards = game.numberOfCards

        XCTAssertEqual(numberOfCards, numberOfCardsToCreate, "")
    }

    func test_chooseCardWithNumber_PickingChosenCard_AppliesNoPenalty() {
        let game = TestGameFactory().makePlayingCardMatchingGame()

        let expected = game.score - TestGameFactory().makeGamePointsConfiguration().choosePenalty
        2.times { game.chooseCardWithNumber(0)}

        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingMatchingSuits_AppliesReward() {
        let game = TestGameFactory().makeGameWithFirstThreeCardsMatchingWithSuits()
        let points = TestGameFactory().makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.suitMatchReward
        0.upto(1) { game.chooseCardWithNumber($0) }
        let newScore = game.score
        
        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingMatchingRanks_AppliesReward() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()
        let points = TestGameFactory().makeGamePointsConfiguration()
        let expected = game.score - points.choosePenalty * 2 + points.rankMatchReward

        0.upto(1) { game.chooseCardWithNumber($0) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingMismatchedCards_AppliesPenalty() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        let points = TestGameFactory().makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 - points.mismatchPenalty
        0.upto(1) { game.chooseCardWithNumber($0) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_MatchedCards_AreInactiveTryingToFlipThemDoesntChangeTheScore() {
        let game = TestGameFactory().makeGameWithFirstThreeCardsMatchingWithSuits()
        func flipBothCards() {
            0.upto(1) { game.chooseCardWithNumber($0) }
        }

        flipBothCards()
        let expected = game.score
        2.times(flipBothCards)
        let result = game.score

        XCTAssertEqual(result, expected, "")
    }

    func test_pickedCardWithNumber_MismatchedCard_IsAvailableForPicking() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        let points = TestGameFactory().makeGamePointsConfiguration()

        let expected = game.score - points.choosePenalty * 2 + points.suitMatchReward
        0.upto(1) { game.chooseCardWithNumber($0) }
        let earlierScore = game.score
        2.times { game.chooseCardWithNumber(1) }
        let result = game.score

        XCTAssertNotEqual(result, earlierScore, "")
    }

    func test_pickedCardWithNumber_PickingSameCardTwoTimesInTheRow_AppliesPenaltyTwice() {
        let game = TestGameFactory().makePlayingCardMatchingGame()
        func chooseWithPenaltyTwoTimes() {
            3.times { game.chooseCardWithNumber(0) }
        }
        let expected = game.score - 2 * TestGameFactory().makeGamePointsConfiguration().choosePenalty
        chooseWithPenaltyTwoTimes()
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_setNumberOfCardsToMatch_BeforeChoosingAnyCard_SetsProperly() {
        let game = TestGameFactory().makePlayingCardMatchingGame()
        let needToMatch = game.numberOfCardsToMatch + 1
        game.numberOfCardsToMatch = needToMatch

        let result = game.numberOfCardsToMatch
        XCTAssertEqual(result, needToMatch, "")
    }

    func test_setNumberOfCardsToMatch_BeforeAnyCards_IgnoresNewSetting() {
        let game = TestGameFactory().makePlayingCardMatchingGame()
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

    func test_chooseCardWithNumber_PickingThreeMatchingSuits_AppliesReward() {
        let game = TestGameFactory().makeGameWithFirstThreeCardsMatchingWithSuits()
        game.numberOfCardsToMatch = 3
        let points = TestGameFactory().makeGamePointsConfiguration()
        let expected = game.score - points.choosePenalty * 3 + points.suitMatchReward + game.difficultyBonus()
        3.times { game.chooseCardWithNumber($0) }

        let newScore = game.score
        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_AppliesPenalty() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        let points = TestGameFactory().makeGamePointsConfiguration()
        let cardsToMatchCount = 3
        game.numberOfCardsToMatch = cardsToMatchCount

        let expected = game.score - points.choosePenalty * cardsToMatchCount - points.mismatchPenalty
        cardsToMatchCount.times { game.chooseCardWithNumber($0) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_FirstTwoCardsAreAvailableToChose() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()

        0.upto(2) { game.chooseCardWithNumber($0) }

        let cardsAreAvailable = !game.isCardChosen(0) && !game.isCardChosen(1)
        XCTAssertTrue(cardsAreAvailable, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_FirstCardIsNotChosen() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        game.numberOfCardsToMatch = 3

        0.upto(2) { game.chooseCardWithNumber($0) }

        let chosen = game.isCardChosen(0)
        XCTAssertFalse(chosen, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_SecondCardIsNotChosen() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        game.numberOfCardsToMatch = 3

       0.upto(2) { game.chooseCardWithNumber($0) }

        let chosen = game.isCardChosen(1)
        XCTAssertFalse(chosen, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_LastCardIsNotAvailableToChose() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()

        0.upto(2) { game.chooseCardWithNumber($0) }

        let cardIsChosen = game.isCardChosen(2)
        XCTAssertTrue(cardIsChosen, "")
    }

    func test_chooseCardWithNumber_PickingThreeMatchingRanks_AppliesReward() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()
        let points = TestGameFactory().makeGamePointsConfiguration()
        let expected = game.score - points.choosePenalty * 3 + points.rankMatchReward
        0.upto(2) { game.chooseCardWithNumber($0) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_FullyFlippingCardAndFlippingOtherMatchingCardOnce_DoesntProduceAMatch() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()

        2.times { game.chooseCardWithNumber(1) }
        game.chooseCardWithNumber(0)

        let expected = game.matchedCardsIndexes.isEmpty
        XCTAssertTrue(expected, "")
    }

    func test_chooseCardWithNumber_FullyFlippingCard_ClearsCurrenltyChosenIndexes() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()

        2.times { game.chooseCardWithNumber(1) }

        let noChosenIndexes = game.chosenCardsIndexes.isEmpty
        XCTAssertTrue(noChosenIndexes, "")
    }

    func test_chooseCardWithNumber_TwoCardsOutOfThreeMatchWithSuit_AppliesRewardForPartialMatch() {
        let cardsWithTwoMachingSuits = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Three)]
        let game = TestGameFactory().makePlayingCardMatchingGameWithStubDeck(cards: cardsWithTwoMachingSuits)
        let matchCount = 3
        game.numberOfCardsToMatch = matchCount
        let points = TestGameFactory().makeGamePointsConfiguration()
        let expectedScore = game.score - points.choosePenalty * matchCount + Int(points.partialMatchMultiplier * Double(points.suitMatchReward)) + game.difficultyBonus()

        0.upto(2) { game.chooseCardWithNumber($0) }

        let currentScore = game.score
        XCTAssertEqual(currentScore, expectedScore, "")
    }
}

class TestGameFactory {
    func makeGameWithFirstThreeCardsMatchingWithSuits() -> PlayingCardMatchingGame {
        let matchingSuits = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Three), PlayingCard(suit: .Hearts, rank: .Four)]
        return makePlayingCardMatchingGameWithStubDeck(cards: matchingSuits)
    }

    func makeGameWithFirstTwoCardsMatchingWithRanks() -> PlayingCardMatchingGame {
        let cards = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Hearts, rank: .Two)]
        return makePlayingCardMatchingGameWithStubDeck(cards: cards)
    }

    func makeGameWithFirstThreeMismatchedCards() -> PlayingCardMatchingGame {
        let mismatched = [PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Three), PlayingCard(suit: .Diamonds, rank: .Four)]
        return makePlayingCardMatchingGameWithStubDeck(cards: mismatched)
    }

    func makeGameWithCard(card: PlayingCard) -> PlayingCardMatchingGame {
        return makePlayingCardMatchingGameWithStubDeck(cards: [card])
    }

    func makePlayingCardMatchingGame(cardCount: Int = 12, numberOfcardsToMatch: Int = 2) -> PlayingCardMatchingGame {
        return PlayingCardMatchingGame(configuration: makeGamePointsConfiguration(), numberOfCards: cardCount, numberOfCardsToMatch: numberOfcardsToMatch)
    }

    func makePlayingCardMatchingGameWithStubDeck(cards c: [PlayingCard], cardCount: Int = 12) -> PlayingCardMatchingGame {
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

        return PlayingCardMatchingGame(configuration: makeGamePointsConfiguration(), numberOfCards: cardCount, numberOfCardsToMatch: 2, deck: stubDeck)
    }

    func makeGamePointsConfiguration() -> PointsConfiguration {
        return PointsConfiguration(choosePenalty: 1, suitMatchReward: 4, rankMatchReward: 16, mismatchPenalty: 2, partialMatchMultiplier: 0.5)
    }
}
