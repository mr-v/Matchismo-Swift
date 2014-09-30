//
//  CardViewModelTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

class CardViewModelTests: XCTestCase {

    func test_scoreText_AfterInitialization_ReturnsProperlyFormattedText() {
        let viewModel = makeCardViewModel(TestGameFactory().makeMatchingGame())

        let text = viewModel.scoreText

        XCTAssertEqual("Score: 0", text, "")
    }

    func test_matchedCardNumbers_Returns_IndexesOfCardsThatWereMatched() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()
        let viewModel = makeCardViewModel(game)

        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)

        let matchedNumbers = viewModel.matchedCardNumbers

        XCTAssertEqual(matchedNumbers, [0, 1], "")
    }

    func test_currentlyAvailableCardsNumbers_AfterMatch_DoesntContainMatchedCardsNumbers() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()
        let viewModel = makeCardViewModel(game)

        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)

        let numbers = viewModel.currentlyAvailableCardsNumbers()
        let containsMatchCardNumbers = contains(numbers, 0) && contains(numbers, 1)

        XCTAssertFalse(containsMatchCardNumbers, "")
    }

    func test_currentlyAvailableCardsNumbers_AfterMismatch_ContainsNumberOfTheFirstChosenCard() {
        let game = TestGameFactory().makeGameWithFirstTwoMismatchedCards()
        let viewModel = makeCardViewModel(game)

        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)

        let numbers = viewModel.currentlyAvailableCardsNumbers()
        let containsFirstCardNumber = contains(numbers, 0)

        XCTAssertTrue(containsFirstCardNumber, "")
    }

    func test_textForCardWithNumber_Called_ProperlyFormattedText() {
        let card = PlayingCard(suit: .Hearts, rank: .Ace)
        let game = TestGameFactory().makeGameWithCard(card)
        let viewModel = makeCardViewModel(game)
        let expected = "A♥"

        let title = viewModel.textForCardWithNumber(0)

        XCTAssertEqual(title, expected, "")
    }

    // MARK:

    func makeCardViewModel(game: MatchingGame) -> CardViewModel  {
        return CardViewModel(game: game)
    }
}
