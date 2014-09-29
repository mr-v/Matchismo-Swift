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
        let (viewModel, _) = makeCardViewModel()

        let text = viewModel.scoreText

        XCTAssertEqual("Score: 0", text, "")
    }

//    func test_matchedCardNumbers_Returns_IndexesOfCardsThatWereMatched() -> [Int] {
//        let (viewModel, game) = makeCardViewModel()
//
////        game.
//
//    }

//    func test_flipCountText_AfterInrementing_ReturnsProperlyFormattedText() {
//        let viewModel = makeCardViewModel()
//
//        viewModel.incrementFlipCount()
//        let text = viewModel.flipCountText()
//
//        XCTAssertEqual("Flips: 1", text, "")
//
//    }
//
//    func test_currentCardTitle_AfterSingleFlip_DoesntChange() {
//        let viewModel = makeCardViewModel()
//
//        let old = viewModel.currentCardTitle
//        viewModel.incrementFlipCount()
//        let newValue = viewModel.currentCardTitle
//
//        XCTAssertEqual(old, newValue, "")
//        
//    }
//
//    func test_currentCardTitle_AfterTwoFlips_Changes() {
//        let viewModel = makeCardViewModel()
//
//        let old = viewModel.currentCardTitle
//        for _ in 1...2 {
//            viewModel.incrementFlipCount()
//        }
//        let newValue = viewModel.currentCardTitle
//
//        XCTAssertNotEqual(old, newValue, "")
//    }


    // MARK:

    func makeCardViewModel() -> (CardViewModel, MatchingGame)  {
        let points = PointsConfiguration(choosePenalty: 1, suitMatchReward: 4, rankMatchReward: 16, mismatchPenalty: 2)
        let game = MatchingGame(configuration: points, numberOfCards: 12)
        return (CardViewModel(game: game), game)
    }
}
