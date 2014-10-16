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

        for i in 0...1 { viewModel.chooseCardWithNumber(i) }

        let matchedNumbers = [0, 1].filter { viewModel.isCardMatched($0) }
        XCTAssertEqual(matchedNumbers, [0, 1])
    }

    func test_currentlyAvailableCardsNumbers_AfterMatch_DoesntContainMatchedCardsNumbers() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(twoRankMatchingCards)

        for i in 0...1 { viewModel.chooseCardWithNumber(i) }

        let numbers = viewModel.currentlyAvailableCardsNumbers()
        let containsMatchCardNumbers = contains(numbers, 0) && contains(numbers, 1)
        XCTAssertFalse(containsMatchCardNumbers)
    }

    func test_currentlyAvailableCardsNumbers_AfterMismatch_ContainsNumberOfTheFirstChosenCard() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(threeMismatchedCards)

        for i in 0...1 { viewModel.chooseCardWithNumber(i) }

        let numbers = viewModel.currentlyAvailableCardsNumbers()
        let containsFirstCardNumber = contains(numbers, 0)

        XCTAssertTrue(containsFirstCardNumber)
    }

    func test_redeal_RestartsGame() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(threeSuitMatchingCards)

        for i in 0...2  { viewModel.chooseCardWithNumber(i) }
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

    func test_redeal_ResetsStatistics() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(threeSuitMatchingCards)
        let cleanStats = viewModel.currentlyAvailableCardsNumbers()

        for i in 0...2 { viewModel.chooseCardWithNumber(i) }
        viewModel.redeal()

        let statsAfterRestart = viewModel.currentlyAvailableCardsNumbers()
        XCTAssertEqual(statsAfterRestart, cleanStats)
    }
}

