//
//  CardViewModelTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

extension CardViewModel {
    var score: Int {
        get { return game.score }
    }
    var matchedCardsIndexes: [Int] {
        get { return game.matchedCardsIndexes.keys.array }
    }
    var currentlyChosenCardIndexes: [Int] {
        get { return game.currentlyChosenCardIndexes }
    }
    var numberOfCardsToMatch: Int {
        get { return game.numberOfCardsToMatch }
    }
}

// MARK: -

class CardViewModelTests: XCTestCase {

    func test_scoreText_AfterInitialization_TextWithDefaultScore() {
        let viewModel = makeCardViewModel(TestGameFactory().makePlayingCardMatchingGame())

        let text = viewModel.scoreText

        XCTAssertEqual("Score: 0", text, "")
    }

    func test_isCardChosen_ChoosingTwoMatchingCards_TracksThemAsChosen() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()
        let viewModel = makeCardViewModel(game)

        0.upto(1) { game.chooseCardWithNumber($0) }

        let matchedNumbers = [0, 1].filter { viewModel.isCardChosen($0) }
        XCTAssertEqual(matchedNumbers, [0, 1], "")
    }

    func test_currentlyAvailableCardsNumbers_AfterMatch_DoesntContainMatchedCardsNumbers() {
        let game = TestGameFactory().makeGameWithFirstTwoCardsMatchingWithRanks()
        let viewModel = makeCardViewModel(game)

        0.upto(1) { game.chooseCardWithNumber($0) }

        let numbers = viewModel.currentlyAvailableCardsNumbers()
        let containsMatchCardNumbers = contains(numbers, 0) && contains(numbers, 1)
        XCTAssertFalse(containsMatchCardNumbers, "")
    }

    func test_currentlyAvailableCardsNumbers_AfterMismatch_ContainsNumberOfTheFirstChosenCard() {
        let game = TestGameFactory().makeGameWithFirstThreeMismatchedCards()
        let viewModel = makeCardViewModel(game)

        0.upto(1) { game.chooseCardWithNumber($0) }

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

    func test_redeal_RestartsGame() {
        let viewModel = makeCardViewModel(TestGameFactory().makeGameWithFirstThreeCardsMatchingWithSuits())

        1.upto(3) { viewModel.chooseCardWithNumber($0) }
        let scoreAfterMismatch = viewModel.score
        viewModel.redeal()

        let scoreIsReset = viewModel.score != scoreAfterMismatch
        let restarted = scoreIsReset && viewModel.matchedCardsIndexes.isEmpty && viewModel.currentlyChosenCardIndexes.isEmpty
        XCTAssertTrue(restarted, "")
    }

    func test_redeal_NumberOfCardsToMatchIsKept() {
        let game = TestGameFactory().makePlayingCardMatchingGame()
        let viewModel = makeCardViewModel(game)

        let newSetting = game.numberOfCardsToMatch + 1
        game.numberOfCardsToMatch = newSetting

        viewModel.redeal()

        let currentNumberToMatch = viewModel.numberOfCardsToMatch
        XCTAssertEqual(currentNumberToMatch, newSetting, "")
    }

    func test_changeModeWithNumberOfCardsToMatch_UpdatesGame() {
        let game = TestGameFactory().makePlayingCardMatchingGame()
        let viewModel = makeCardViewModel(game)
        let expected = game.numberOfCardsToMatch + 1

        viewModel.changeModeWithNumberOfCardsToMatch(expected)

        let currentMatchModeCount = viewModel.numberOfCardsToMatch
        XCTAssertEqual(currentMatchModeCount, expected, "")
    }

    func test_lastActionText_ByDefault_ReturnsEmptyText() {
        let game = TestGameFactory().makePlayingCardMatchingGame()
        let viewModel = makeCardViewModel(game)

        let emptyText = viewModel.lastActionText()
        XCTAssertEqual(emptyText, "", "")
    }

    func test_lastActionText_PickingSingleCard_ReturnsTextWithItsTitle() {
        let card = PlayingCard(suit: .Hearts, rank: .Ace)
        let game = TestGameFactory().makePlayingCardMatchingGameWithStubDeck(cards: [card])
        let viewModel = makeCardViewModel(game)

        viewModel.chooseCardWithNumber(0)

        let cardTitle = viewModel.lastActionText()
        XCTAssertEqual(cardTitle, "A♥", "")
    }

    func test_lastActionText_PickingTwoCardInMultiMatchMode_ReturnsTextWithTheirTitle() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Hearts, rank: .Ten)]
        let game = TestGameFactory().makePlayingCardMatchingGameWithStubDeck(cards: cards)
        game.numberOfCardsToMatch = 3
        let viewModel = makeCardViewModel(game)

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let cardTitles = viewModel.lastActionText()
        XCTAssertEqual(cardTitles, "A♥, 10♥", "")
    }

    func test_lastActionText_PickingTwoMatchingCardInTwoMatchMode_ReturnsTextWithMatchedText() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Hearts, rank: .Ten)]
        let viewModel = makeCardViewModel(TestGameFactory().makePlayingCardMatchingGameWithStubDeck(cards: cards))
        let points = TestGameFactory().makeGamePointsConfiguration().suitMatchReward

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let matchedCardsText = viewModel.lastActionText()
        XCTAssertEqual(matchedCardsText, "Matched A♥, 10♥ for \(points)", "")
    }

    func test_lastActionText_PickingMismatchedCardsInTwoMatchMode_ReturnsTextWithMismatchPenalty() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Spades, rank: .Ten)]
        let viewModel = makeCardViewModel(TestGameFactory().makePlayingCardMatchingGameWithStubDeck(cards: cards))
        let points = TestGameFactory().makeGamePointsConfiguration().mismatchPenalty

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let mismatchedCardsText = viewModel.lastActionText()
        XCTAssertEqual(mismatchedCardsText, "A♥, 10♠ don't match! \(points) points penalty!", "")
    }

    func test_lastActionText_FullyFlippingCard_ReturnsEmptyText() {
        let viewModel = makeCardViewModel(TestGameFactory().makePlayingCardMatchingGame())
        let expected = ""

        2.times { viewModel.chooseCardWithNumber(0) }

        let emptyText = viewModel.lastActionText()
        XCTAssertEqual(emptyText, expected, "")
    }

    func test_lastActionText_FullyFlippingCardAndFlippingUpSecondCardInTwoMatchMode_ReturnsTextWithCurrenltyFlippedCard() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Spades, rank: .Ten)]
        let game = TestGameFactory().makePlayingCardMatchingGameWithStubDeck(cards: cards)
        game.numberOfCardsToMatch = 3
        let viewModel = makeCardViewModel(game)
        let expected = "10♠"

        viewModel.chooseCardWithNumber(1)
        2.times { viewModel.chooseCardWithNumber(0) }

        let cardTitle = viewModel.lastActionText()
        XCTAssertEqual(cardTitle, expected, "")
    }

    func test_redeal_ResetsStatistics() {
        let viewModel = makeCardViewModel(TestGameFactory().makeGameWithFirstThreeCardsMatchingWithSuits())
        let cleanStats = viewModel.currentlyAvailableCardsNumbers()

        3.times{ viewModel.chooseCardWithNumber($0) }
        viewModel.redeal()

        let statsAfterRestart = viewModel.currentlyAvailableCardsNumbers()
        XCTAssertEqual(statsAfterRestart, cleanStats, "")
    }

    // MARK:

    func makeCardViewModel(game: PlayingCardMatchingGame) -> CardViewModel  {
        return CardViewModel(game: game)
    }
}

