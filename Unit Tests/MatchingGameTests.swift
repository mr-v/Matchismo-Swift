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
        let game = makePlayingCardMatchingGame()

        let score = game.score

        XCTAssertEqual(score, 0, "")
    }

    func test_MatchingGame_Created_CardsNotChosenByDefault() {
        let game = makePlayingCardMatchingGame()

        var chosen = false
        game.numberOfCardsToMatch.times { chosen |= game.isCardChosen($0) }

        XCTAssertFalse(chosen, "")
    }

    func test_chooseCardWithNumber_FirstTime_ChangesChosenToTrue() {
        let game = makePlayingCardMatchingGame()

        game.chooseCardWithNumber(0)

        var chosen = game.isCardChosen(0)
        XCTAssertTrue(chosen, "")
    }

    func test_chooseCardWithNumber_ChoosingCardTwoTimes_CardIsNotChosen() {
        let game = makePlayingCardMatchingGame()

        2.times { game.chooseCardWithNumber(0) }

        var chosen = game.isCardChosen(0)
        XCTAssertFalse(chosen, "")
    }

    func test_chooseCardWithNumber_PickingUnchosenCard_AppliesPenalty() {
        let game = makePlayingCardMatchingGame()

        let expected = game.score + choosePenalty
        game.chooseCardWithNumber(0)
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingChosenCard_AppliesNoPenalty() {
        let game = makePlayingCardMatchingGame()

        let expected = game.score + choosePenalty
        2.times { game.chooseCardWithNumber(0)}

        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingMatchingSuits_AppliesReward() {
        let game = makeGameWithFirstThreeCardsMatchingWithSuits()

        let expected = game.score + choosePenalty * 2 + suitReward
        0.upto(1) { game.chooseCardWithNumber($0) }
        let newScore = game.score
        
        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingMatchingRanks_AppliesReward() {
        let game = makeGameWithFirstTwoCardsMatchingWithRanks()
        let expected = game.score + choosePenalty * 2 + rankReward

        0.upto(1) { game.chooseCardWithNumber($0) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingMismatchedCards_AppliesPenalty() {
        let game = makeGameWithFirstThreeMismatchedCards()

        let expected = game.score + choosePenalty * 2 + mismatchPenalty
        0.upto(1) { game.chooseCardWithNumber($0) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_MatchedCards_AreInactiveTryingToFlipThemDoesntChangeTheScore() {
        let game = makeGameWithFirstThreeCardsMatchingWithSuits()
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
        let game = makeGameWithFirstThreeMismatchedCards()

        let expected = game.score + choosePenalty * 2 + suitReward
        0.upto(1) { game.chooseCardWithNumber($0) }
        let earlierScore = game.score
        2.times { game.chooseCardWithNumber(1) }
        let result = game.score

        XCTAssertNotEqual(result, earlierScore, "")
    }

    func test_pickedCardWithNumber_PickingSameCardTwoTimesInTheRow_AppliesPenaltyTwice() {
        let game = makePlayingCardMatchingGame()
        func chooseWithPenaltyTwoTimes() {
            3.times { game.chooseCardWithNumber(0) }
        }
        let expected = game.score + 2 * choosePenalty
        chooseWithPenaltyTwoTimes()
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_setNumberOfCardsToMatch_BeforeChoosingAnyCard_AppliesNewSetting() {
        let game = makePlayingCardMatchingGame()
        let needToMatch = game.numberOfCardsToMatch + 1
        game.numberOfCardsToMatch = needToMatch

        let result = game.numberOfCardsToMatch
        XCTAssertEqual(result, needToMatch, "")
    }

    func test_setNumberOfCardsToMatch_BeforeAnyCards_IgnoresNewSetting() {
        let game = makePlayingCardMatchingGame()
        let needToMatch = game.numberOfCardsToMatch + 1
        game.chooseCardWithNumber(0)
        game.numberOfCardsToMatch = needToMatch

        let result = game.numberOfCardsToMatch
        XCTAssertNotEqual(result, needToMatch, "")
    }

    func test_setNumberOfCardsToMatch_AfterFullyFlippingCard_DoesntAllowToChangeMatchMode() {
        let game = makeGameWithFirstTwoCardsMatchingWithRanks()
        let currentMode = game.numberOfCardsToMatch

        2.times { game.chooseCardWithNumber(1) }
        game.numberOfCardsToMatch = currentMode + 1

        let notChanged = game.numberOfCardsToMatch == currentMode
        XCTAssertTrue(notChanged, "")
    }

    // MARK: - Matching multiple cards (3+)

    func test_matchedCardNumbers_MatchingAgainstThreeCards_IndexesOfCardsThatWereMatched() {
        let game = makeGameWithFirstThreeCardsMatchingWithSuits()
        game.numberOfCardsToMatch = 3
        let expected = [0, 1, 2]

        for i in expected { game.chooseCardWithNumber(i) }

        var matchedNumbers = game.matchedCardsIndexes.keys.array
        matchedNumbers.sort(<)
        XCTAssertEqual(matchedNumbers, expected, "")
    }

    func test_chooseCardWithNumber_PickingThreeMatchingSuits_AppliesReward() {
        let game = makeGameWithFirstThreeCardsMatchingWithSuits()
        game.numberOfCardsToMatch = 3
        let scoreWithoutBonus = game.score + choosePenalty * 3 + suitReward
        3.times { game.chooseCardWithNumber($0) }

        let newScore = game.score
        XCTAssertGreaterThan(newScore, scoreWithoutBonus, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_AppliesPenalty() {
        let game = makeGameWithFirstThreeMismatchedCards()
        let cardsToMatchCount = 3
        game.numberOfCardsToMatch = cardsToMatchCount

        let expected = game.score + choosePenalty * cardsToMatchCount + mismatchPenalty
        cardsToMatchCount.times { game.chooseCardWithNumber($0) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_FirstTwoCardsAreAvailableToChose() {
        let game = makeGameWithFirstThreeMismatchedCards()

        0.upto(2) { game.chooseCardWithNumber($0) }

        let cardsAreAvailable = !game.isCardChosen(0) && !game.isCardChosen(1)
        XCTAssertTrue(cardsAreAvailable, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_FirstCardIsNotChosen() {
        let game = makeGameWithFirstThreeMismatchedCards()
        game.numberOfCardsToMatch = 3

        0.upto(2) { game.chooseCardWithNumber($0) }

        let chosen = game.isCardChosen(0)
        XCTAssertFalse(chosen, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_SecondCardIsNotChosen() {
        let game = makeGameWithFirstThreeMismatchedCards()
        game.numberOfCardsToMatch = 3

       0.upto(2) { game.chooseCardWithNumber($0) }

        let chosen = game.isCardChosen(1)
        XCTAssertFalse(chosen, "")
    }

    func test_chooseCardWithNumber_PickingThreeMismatchedCards_LastCardIsNotAvailableToChose() {
        let game = makeGameWithFirstThreeMismatchedCards()

        0.upto(2) { game.chooseCardWithNumber($0) }

        let cardIsChosen = game.isCardChosen(2)
        XCTAssertTrue(cardIsChosen, "")
    }

    func test_chooseCardWithNumber_PickingThreeMatchingRanks_AppliesReward() {
        let game = makeGameWithFirstTwoCardsMatchingWithRanks()
        let expected = game.score + choosePenalty * 3 + rankReward
        0.upto(2) { game.chooseCardWithNumber($0) }
        let newScore = game.score

        XCTAssertEqual(newScore, expected, "")
    }

    func test_chooseCardWithNumber_FullyFlippingCardAndFlippingOtherMatchingCardOnce_DoesntProduceAMatch() {
        let game = makeGameWithFirstTwoCardsMatchingWithRanks()

        2.times { game.chooseCardWithNumber(1) }
        game.chooseCardWithNumber(0)

        let expected = game.matchedCardsIndexes.isEmpty
        XCTAssertTrue(expected, "")
    }

    func test_chooseCardWithNumber_FullyFlippingCard_ClearsCurrenltyChosenIndexes() {
        let game = makeGameWithFirstTwoCardsMatchingWithRanks()

        2.times { game.chooseCardWithNumber(1) }

        let noChosenIndexes = game.chosenCardsIndexes.isEmpty
        XCTAssertTrue(noChosenIndexes, "")
    }

    func test_chooseCardWithNumber_TwoCardsOutOfThreeMatchWithSuit_AppliesRewardForPartialMatch() {
        let cardsWithTwoMachingSuits = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Hearts, rank: .Two), PlayingCard(suit: .Spades, rank: .Three)]
        let game = makePlayingCardMatchingGameWithStubDeck(cards: cardsWithTwoMachingSuits)
        let matchCount = 3
        game.numberOfCardsToMatch = matchCount
        let scoreWithNoBonus = game.score + choosePenalty * matchCount + Int(partialMatchMultiplier * Double(suitReward))

        0.upto(2) { game.chooseCardWithNumber($0) }

        let currentScore = game.score
        XCTAssertGreaterThan(currentScore, scoreWithNoBonus, "")
    }
}

