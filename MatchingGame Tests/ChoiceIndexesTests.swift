//
//  ChoiceIndexesTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 16/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class ChoiceIndexesTests: XCTestCase {

    // MARK: - Matching Game

    func test_chooseCardWithNumber_AfterMatchingTwoCards_ReturnsMatchedIndexes() {
        let game = makeGameWithFirstTwoCardsMatchingWithRanks()

        game.chooseCardWithNumber(0)
        let results = game.chooseCardWithNumber(1)

        XCTAssertEqual(results.matched, [0, 1])
    }

    func test_chooseCardWithNumber_AfterMismatch_ReturnsIndexOfFirstCardAsUnchosen() {
        let game = makeGameWithFirstThreeMismatchedCards()

        game.chooseCardWithNumber(0)
        let results = game.chooseCardWithNumber(1)

        XCTAssertEqual(results.unchosen, [0])
    }

    func test_chooseCardWithNumber_AfterMismatch_ReturnsNoMatchedIndexes() {
        let game = makeGameWithFirstThreeMismatchedCards()

        game.chooseCardWithNumber(0)
        let results = game.chooseCardWithNumber(1)

        XCTAssertTrue(results.matched.isEmpty)
    }

    func test_chooseCardWithNumber_ThreeMatchModeAfterMismatch_ReturnsIndexesOfFirstTwoCardsAsUnchosen() {
        let game = makeGameWithFirstThreeMismatchedCards()
        game.numberOfCardsToMatch = 3

        game.chooseCardWithNumber(0)
        game.chooseCardWithNumber(1)
        let results = game.chooseCardWithNumber(2)

        XCTAssertEqual(results.unchosen, [0, 1])
    }

    func test_viewModelchooseCardWithNumber_AfterMatchingTwoCards_ReturnsMatchedIndexPaths() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(twoRankMatchingCards)
        let expected = [0, 1]

        viewModel.chooseCardWithNumber(0)
        let results: CardChoiceResult<NSIndexPath> = viewModel.chooseCardWithNumber(1)
        let matchedIndexes = results.matched.map { path in path.row }
        XCTAssertEqual(matchedIndexes, expected)
    }

    func test_viewModelchooseCardWithNumber_AfterMatchingTwoCards_ReturnsNoUnchosenIndexPaths() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(twoRankMatchingCards)
        let expected = [0, 1]

        viewModel.chooseCardWithNumber(0)
        let results: CardChoiceResult<NSIndexPath> = viewModel.chooseCardWithNumber(1)

        XCTAssertTrue(results.unchosen.isEmpty)
    }

    func test_viewModelcchooseCardWithNumber_AfterMismatch_ReturnsIndexPathOfFirstCardAsUnchosen() {
        let viewModel = makeGameViewModelWithPlayingCardsGame(threeMismatchedCards)

        viewModel.chooseCardWithNumber(0)
        let results = viewModel.chooseCardWithNumber(1)
        let unchosen = results.unchosen.map { path in path.row }

        XCTAssertEqual(unchosen, [0])
    }


}
