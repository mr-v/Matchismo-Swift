//
//  CardViewModelTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

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

    func test_currentCardTitle_AfterSingleFlip_DoesntChange() {
        let viewModel = makeCardViewModel()

        let old = viewModel.currentCardTitle
        viewModel.incrementFlipCount()
        let newValue = viewModel.currentCardTitle

        XCTAssertEqual(old, newValue, "")
        
    }

    func test_currentCardTitle_AfterTwoFlips_Changes() {
        let viewModel = makeCardViewModel()

        let old = viewModel.currentCardTitle
        for _ in 1...2 {
            viewModel.incrementFlipCount()
        }
        let newValue = viewModel.currentCardTitle

        XCTAssertNotEqual(old, newValue, "")
    }

    func test_isDeckEmpty_AfterPullingAllTheCards_ReturnsTrue() {
        let viewModel = makeViewModelWithEmptyDeck()

        let empty = viewModel.isDeckEmpty

        XCTAssertTrue(empty, "")
    }

    // MARK:

    func makeCardViewModel(deck: Deck = Deck()) -> CardViewModel {
        return CardViewModel(gameStats: GameStats(), deck: deck)
    }

    func makeViewModelWithEmptyDeck() -> CardViewModel {
        let deck: Deck = Deck()
        for _ in 1...deck.initialNumberOfCards {
            deck.drawACard()
        }
        return makeCardViewModel(deck: deck)
    }
}
