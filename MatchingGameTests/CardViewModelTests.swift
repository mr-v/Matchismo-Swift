//
//  GameViewModelTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

extension GameViewModel {
    var score: Int {
        get { return game.score }
    }
    var matchedCardsIndexes: [Int] {
        get { return game.matchedCardsIndexes.keys.array }
    }
    var chosenCardIndexes: [Int] {
        get { return game.chosenCardsIndexes.keys.array }
    }
    var numberOfCardsToMatch: Int {
        get { return game.numberOfCardsToMatch }
    }
}

// MARK: -

class GameViewModelTests: XCTestCase {

    func test_scoreText_AfterInitialization_TextWithDefaultScore() {
        let viewModel = makeGameViewModelWithPlayingCardsGame()

        let text = viewModel.scoreText

        XCTAssertEqual("Score: 0", text)
    }

    func test_isCardChosen_ChoosingTwoMatchingCards_TracksThemAsMatched() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(twoRankMatchingCards)

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let matchedNumbers = [0, 1].filter { viewModel.isCardMatched($0) }
        XCTAssertEqual(matchedNumbers, [0, 1])
    }

    func test_currentlyAvailableCardsNumbers_AfterMatch_DoesntContainMatchedCardsNumbers() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(twoRankMatchingCards)

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let numbers = viewModel.currentlyAvailableCardsNumbers()
        let containsMatchCardNumbers = contains(numbers, 0) && contains(numbers, 1)
        XCTAssertFalse(containsMatchCardNumbers)
    }

    func test_currentlyAvailableCardsNumbers_AfterMismatch_ContainsNumberOfTheFirstChosenCard() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(threeMismatchedCards)

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let numbers = viewModel.currentlyAvailableCardsNumbers()
        let containsFirstCardNumber = contains(numbers, 0)

        XCTAssertTrue(containsFirstCardNumber)
    }

    func test_textForCardWithNumber_Called_ProperlyFormattedText() {
        let viewModel = makeGameViewModelWithPlayingCardsGame([PlayingCard(suit: .Hearts, rank: .Ace)])
        let expected = "A♥"

        let title = viewModel.textForCardWithNumber(0).string

        XCTAssertEqual(title, expected)
    }

    func test_redeal_RestartsGame() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(threeSuitMatchingCards)

        0.upto(2) { viewModel.chooseCardWithNumber($0) }
        let scoreAfterMismatch = viewModel.score
        viewModel.redeal()

        let scoreIsReset = viewModel.score != scoreAfterMismatch

        let restarted = scoreIsReset && viewModel.matchedCardsIndexes.isEmpty && viewModel.chosenCardIndexes.isEmpty
        XCTAssertTrue(restarted)
    }

    func test_redeal_NumberOfCardsToMatchIsKept() {
        let viewModel = makeGameViewModelWithPlayingCardsGame()

        let newSetting = viewModel.numberOfCardsToMatch + 1
        viewModel.changeModeWithNumberOfCardsToMatch(newSetting)

        viewModel.redeal()

        let currentNumberToMatch = viewModel.numberOfCardsToMatch
        XCTAssertEqual(currentNumberToMatch, newSetting)
    }

    func test_changeModeWithNumberOfCardsToMatch_UpdatesGame() {
        let viewModel = makeGameViewModelWithPlayingCardsGame()
        let expected = viewModel.numberOfCardsToMatch + 1

        viewModel.changeModeWithNumberOfCardsToMatch(expected)

        let currentMatchModeCount = viewModel.numberOfCardsToMatch
        XCTAssertEqual(currentMatchModeCount, expected)
    }

    func test_lastActionText_ByDefault_ReturnsEmptyText() {
        let viewModel = makeGameViewModelWithPlayingCardsGame()

        let emptyText = viewModel.lastActionText().string
        XCTAssertEqual(emptyText, "")
    }

    func test_lastActionText_PickingSingleCard_ReturnsTextWithItsTitle() {
        let viewModel =  makeGameViewModelWithPlayingCardsGame([PlayingCard(suit: .Hearts, rank: .Ace)])

        viewModel.chooseCardWithNumber(0)

        let cardTitle = viewModel.lastActionText().string
        XCTAssertEqual(cardTitle, "A♥")
    }

    func test_lastActionText_PickingTwoCardInMultiMatchMode_ReturnsTextWithTheirTitle() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Hearts, rank: .Ten)]
        let viewModel = makeGameViewModelWithPlayingCardsGame(cards)
        viewModel.changeModeWithNumberOfCardsToMatch(3)

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let cardTitles = viewModel.lastActionText().string
        XCTAssertEqual(cardTitles, "A♥, 10♥")
    }

    func test_lastActionText_PickingTwoMatchingCardInTwoMatchMode_ReturnsTextWithMatchedText() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Hearts, rank: .Ten)]
        let viewModel = makeGameViewModelWithPlayingCardsGame(cards)

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let matchedCardsText = viewModel.lastActionText().string
        XCTAssertEqual(matchedCardsText, "Matched A♥, 10♥ for \(suitReward)")
    }

    func test_lastActionText_PickingMismatchedCardsInTwoMatchMode_ReturnsTextWithMismatchPenalty() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Spades, rank: .Ten)]
        let viewModel = makeGameViewModelWithPlayingCardsGame(cards)

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let mismatchedCardsText = viewModel.lastActionText().string
        XCTAssertEqual(mismatchedCardsText, "A♥, 10♠ don't match! \(abs(mismatchPenalty)) points penalty!")
    }

    func test_lastActionText_FullyFlippingCard_ReturnsEmptyText() {
        let viewModel = makeGameViewModelWithPlayingCardsGame()
        let expected = ""

        2.times { viewModel.chooseCardWithNumber(0) }

        let emptyText = viewModel.lastActionText().string
        XCTAssertEqual(emptyText, expected)
    }

    func test_lastActionText_FullyFlippingCardAndFlippingUpSecondCardInTwoMatchMode_ReturnsTextWithCurrenltyFlippedCard() {
        let cards = [PlayingCard(suit: .Hearts, rank: .Ace), PlayingCard(suit: .Spades, rank: .Ten)]
        let viewModel = makeGameViewModelWithPlayingCardsGame(cards)
        viewModel.changeModeWithNumberOfCardsToMatch(3)
        let expected = "10♠"

        viewModel.chooseCardWithNumber(1)
        2.times { viewModel.chooseCardWithNumber(0) }

        let cardTitle = viewModel.lastActionText().string
        XCTAssertEqual(cardTitle, expected)
    }

    func test_redeal_ResetsStatistics() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(threeSuitMatchingCards)
        let cleanStats = viewModel.currentlyAvailableCardsNumbers()

        3.times{ viewModel.chooseCardWithNumber($0) }
        viewModel.redeal()

        let statsAfterRestart = viewModel.currentlyAvailableCardsNumbers()
        XCTAssertEqual(statsAfterRestart, cleanStats)
    }

    func test_actionsHistory_PickingCards_TracksEachPick() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(twoRankMatchingCards)

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let actions = viewModel.actionsHistory
        XCTAssertEqual(actions.count, 2)
    }

    func test_actionsHistory_PickingCards_TracksProperText() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(twoRankMatchingCards)
        let expected = ["2♥", "Matched 2♥, 2♠ for \(rankReward)"]

        0.upto(1) { viewModel.chooseCardWithNumber($0) }

        let actions = viewModel.actionsHistory.map { $0.string }
        XCTAssertEqual(actions, expected)
    }

    func test_actionsHistory_AfterRedeal_IsClear() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(twoRankMatchingCards)

        0.upto(1) { viewModel.chooseCardWithNumber($0) }
        viewModel.redeal()

        let actionsCount = viewModel.actionsHistory.count
        XCTAssertEqual(actionsCount, 0)
    }
}

