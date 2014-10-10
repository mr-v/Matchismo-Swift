//
//  SetCardSymbolPrinterTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 09/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest
import UIKit

class SetCardSymbolPrinterTests: XCTestCase {

    func test_attributtedStringForCardWithNumber_SolidShading_TextHasFullAlpha() {
        let card = SetCard(number: .One, symbol: .Oval, shading: .Solid, color: .Red)
        let printer = makeSetCardPrinter(card)
        let expected: CGFloat = 1

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let alpha = alphaFromAttributedString(attributedString)
        XCTAssertEqual(alpha, expected, "")
    }

    func test_attributtedStringForCardWithNumber_StripedShading_TextHasHalfAlpha() {
        let card = SetCard(number: .One, symbol: .Oval, shading: .Striped, color: .Red)
        let printer = makeSetCardPrinter(card)
        let expected: CGFloat = 0.5

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let alpha = alphaFromAttributedString(attributedString)
        XCTAssertEqual(alpha, expected, "")
    }
    func test_attributtedStringForCardWithNumber_OpenShading_TextHasOutline() {
        let card = SetCard(number: .One, symbol: .Oval, shading: .Open, color: .Red)
        let printer = makeSetCardPrinter(card)
        let noOutlineWidth: CGFloat = 0

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let strokeWidth = attributedString.attribute(NSStrokeWidthAttributeName, atIndex: 0, effectiveRange: nil) as CGFloat
        XCTAssertLessThan(strokeWidth, noOutlineWidth, "")
    }

    func test_attributtedStringForCardWithNumber_OpenShading_OutlineHasTextColor() {
        let card = SetCard(number: .One, symbol: .Oval, shading: .Open, color: .Red)
        let printer = makeSetCardPrinter(card)
        let noOutlineWidth: CGFloat = 0

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let textColor = colorFromAttributedString(attributedString)
        let outlineColor = attributedString.attribute(NSStrokeColorAttributeName, atIndex: 0, effectiveRange: nil) as UIColor
        XCTAssertEqual(outlineColor, textColor, "")
    }

    // NSStrokeColorAttributeName

    func test_attributtedStringForCardWithNumber_RedColor_TextIsRed() {
        let card = SetCard(number: .One, symbol: .Oval, shading: .Solid, color: .Red)
        let printer = makeSetCardPrinter(card)
        let redColor = UIColor.redColor()

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let color = colorFromAttributedString(attributedString)
        XCTAssertEqual(color, redColor, "")
    }

    func test_attributtedStringForCardWithNumber_GreenColor_TextIsGreen() {
        let card = SetCard(number: .One, symbol: .Oval, shading: .Solid, color: .Green)
        let printer = makeSetCardPrinter(card)
        let greenColor = UIColor.greenColor()

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let color = colorFromAttributedString(attributedString)
        XCTAssertEqual(color, greenColor, "")
    }

    func test_attributtedStringForCardWithNumber_PurpleColor_TextIsPurple() {
        let card = SetCard(number: .One, symbol: .Oval, shading: .Solid, color: .Purple)
        let printer = makeSetCardPrinter(card)
        let purpleColor = UIColor.purpleColor()

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let color = colorFromAttributedString(attributedString)
        XCTAssertEqual(color, purpleColor, "")
    }

    func test_attributtedStringForCardWithNumber_OneNumber_TextIsOneCharacterLong() {
        let card = SetCard(number: .One, symbol: .Oval, shading: .Solid, color: .Red)
        let printer = makeSetCardPrinter(card)

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let textLength = attributedString.length
        XCTAssertEqual(textLength, 1, "")
    }

    func test_attributtedStringForCardWithNumber_TwoNumber_TextIsTwoCharactersLong() {
        let card = SetCard(number: .Two, symbol: .Oval, shading: .Solid, color: .Red)
        let printer = makeSetCardPrinter(card)

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let textLength = attributedString.length
        XCTAssertEqual(textLength, 2, "")
    }

    func test_attributtedStringForCardWithNumber_ThreeNumber_TextIsThreeCharactersLong() {
        let card = SetCard(number: .Three, symbol: .Oval, shading: .Solid, color: .Red)
        let printer = makeSetCardPrinter(card)

        let attributedString = printer.attributtedStringForCardWithNumber(0)

        let textLength = attributedString.length
        XCTAssertEqual(textLength, 3, "")
    }

    func test_attributtedStringForCardWithNumber_DiamondSymbol_TextHasOnlyDiamonds() {
        let card = SetCard(number: .Three, symbol: .Diamond, shading: .Solid, color: .Red)
        let printer = makeSetCardPrinter(card)
        let diamondSet = NSCharacterSet(charactersInString: SetSymbol.Diamond.rawValue)

        let attributedString = printer.attributtedStringForCardWithNumber(0)
        let textSet = NSCharacterSet(charactersInString: attributedString.string)

        XCTAssertTrue(diamondSet.isSupersetOfSet(textSet), "")
    }

    func test_attributtedStringForCardWithNumber_OvalSymbol_TextHasOnlyOvals() {
        let card = SetCard(number: .Three, symbol: .Oval, shading: .Solid, color: .Red)
        let printer = makeSetCardPrinter(card)
        let ovalSet = NSCharacterSet(charactersInString: SetSymbol.Oval.rawValue)

        let attributedString = printer.attributtedStringForCardWithNumber(0)
        let textSet = NSCharacterSet(charactersInString: attributedString.string)

        XCTAssertTrue(ovalSet.isSupersetOfSet(textSet), "")
    }

    func test_attributtedStringForCardWithNumber_DiamondSquiggle_TextHasOnlySquiggles() {
        let card = SetCard(number: .Three, symbol: .Squiggle, shading: .Solid, color: .Red)
        let printer = makeSetCardPrinter(card)
        let squiggleSet = NSCharacterSet(charactersInString: SetSymbol.Squiggle.rawValue)

        let attributedString = printer.attributtedStringForCardWithNumber(0)
        let textSet = NSCharacterSet(charactersInString: attributedString.string)

        XCTAssertTrue(squiggleSet.isSupersetOfSet(textSet), "")
    }

    // MARK - test helpers

    func colorFromAttributedString(attributedString: NSAttributedString) -> UIColor {
        return attributedString.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil) as UIColor
    }

    func alphaFromAttributedString(attributedString: NSAttributedString) -> CGFloat {
        let color = attributedString.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil) as UIColor
        var alpha:CGFloat = 0
        color.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha
    }

    func makeSetCardPrinter(card: SetCard) -> SetCardSymbolPrinter {
        let matcher = makeSetCardMatcher([card])
        return SetCardSymbolPrinter(matcher: matcher)
    }
}
