//
//  CardSymbolPrintersTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 08/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest
import UIKit

class PlayingCardSymbolPrinterTests: XCTestCase {

    func test_attributtedStringForCardWithNumber_HeartsSuit_ReturnsRedText() {
        let printer = makePrinterWithCards([aceOfHearts])

        let text = printer.attributtedStringForCardWithNumber(0)
        let heartsColor = text.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil) as UIColor

        XCTAssertEqual(heartsColor, UIColor.redColor(), "")
    }

    func test_attributtedStringForCardWithNumber_SpadesSuit_ReturnsBlackText() {
        let printer = makePrinterWithCards([aceOfSpades])

        let text = printer.attributtedStringForCardWithNumber(0)
        let spadesColor = text.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil) as UIColor

        XCTAssertEqual(spadesColor, UIColor.blackColor(), "")
    }


    func test_attributtedStringForCardWithNumber_AceOfHearts_ReturnsProperText() {
        let printer = makePrinterWithCards([aceOfHearts])

        let text = printer.attributtedStringForCardWithNumber(0)

        XCTAssertEqual(text.string, "A♥", "")
    }

    func test_attributtedStringForCardWithNumber_DiamondsSuit_ReturnsRedText() {
        let printer = makePrinterWithCards([aceOfDiamonds])

        var text = printer.attributtedStringForCardWithNumber(0)
        let diamondsColor = text.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil) as UIColor

        XCTAssertEqual(diamondsColor, UIColor.redColor(), "")
    }

    func test_attributtedStringForCardWithNumber_ClubsSuit_ReturnsBlackText() {
        let printer = makePrinterWithCards([aceOfClubs])

        var text = printer.attributtedStringForCardWithNumber(0)
        let clubsColor = text.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil) as UIColor

        XCTAssertEqual(clubsColor, UIColor.blackColor(), "")
    }

    // MARK: -

    let aceOfHearts = PlayingCard(suit: .Hearts, rank: .Ace)
    let aceOfSpades = PlayingCard(suit: .Spades, rank: .Ace)
    let aceOfDiamonds = PlayingCard(suit: .Diamonds, rank: .Ace)
    let aceOfClubs = PlayingCard(suit: .Clubs, rank: .Ace)


    func makePrinterWithCards(cards: [PlayingCard]) -> PlayingCardSymbolPrinter {
        let matchable = makePlayingCardMatcher(cards)
        return PlayingCardSymbolPrinter(matchable: matchable)
    }
}

