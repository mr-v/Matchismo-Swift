//
//  CardViewModelTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class CardViewModelTests: XCTestCase {

    func test_flipCountText_AfterInitialization_ReturnsProperlyFormattedText() {
        let viewModel = makeCardViewModel()

        let text = viewModel.flipCountText()

        XCTAssertEqual("Flips: 0", text, "")
    }

    func test_flipCountText_AfterInrementing_ReturnsProperlyFormattedText() {
        let stats = GameStats()
        let viewModel = makeCardViewModel(stats: stats)

        stats.incrementFlipCount()
        let text = viewModel.flipCountText()

        XCTAssertEqual("Flips: 1", text, "")

    }

    // MARK:

    func makeCardViewModel(stats: GameStats = GameStats()) -> CardViewModel {
        return CardViewModel(gameStats: stats)
    }
}
