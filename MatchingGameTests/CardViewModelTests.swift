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
        let viewModel = makeCardViewModel()

        viewModel.incrementFlipCount()
        let text = viewModel.flipCountText()

        XCTAssertEqual("Flips: 1", text, "")

    }

    // MARK:

    func makeCardViewModel() -> CardViewModel {
        return CardViewModel(gameStats: GameStats())
    }
}
