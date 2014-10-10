//
//  CardSymbolPrinter.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 08/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

protocol CardSymbolPrinter {
    func attributtedStringForCardWithNumber(number: Int) -> NSAttributedString
}

class PlayingCardSymbolPrinter: CardSymbolPrinter {
    private let letterMapping: [Rank: String] = [.Ace: "A", .Jack: "J", .Queen: "Q", .King: "K"]
    private  let matcher: PlayingCardMatcher

    init(matcher: PlayingCardMatcher) {
        self.matcher = matcher
    }

    func attributtedStringForCardWithNumber(number: Int) -> NSAttributedString {
        let card = matcher.cardWithNumber(number)
        let text = textForCard(card)
        var color: UIColor!
        switch card.suit {
        case .Hearts, .Diamonds:
            color = UIColor.redColor()
        case .Clubs, .Spades:
            color = UIColor.blackColor()
        }
        let attributes: [NSObject: AnyObject] = [NSForegroundColorAttributeName: color]
        return NSAttributedString(string: text, attributes: attributes)
    }

    private func textForCard(card: PlayingCard) -> String {
        var rankText = letterMapping[card.rank] ?? String(card.rank.rawValue)
        let suitText = card.suit.rawValue
        return rankText + suitText
    }
}

class SetCardSymbolPrinter: CardSymbolPrinter {
    private let matcher: SetCardMatcher

    init(matcher: SetCardMatcher) {
        self.matcher = matcher
    }

    func attributtedStringForCardWithNumber(number: Int) -> NSAttributedString {
        let card = matcher.cardWithNumber(number)
        var color: UIColor!
        switch card.color {
        case .Red:
            color = UIColor.redColor()
        case .Green:
            color = UIColor.greenColor()
        case .Purple:
            color = UIColor.purpleColor()
        }

        let count = card.number.rawValue
        let symbol = Character(card.symbol.rawValue)
        let text = String(count: count, repeatedValue: symbol)

        var attributes = [NSObject: AnyObject]()
        if card.shading == .Striped {
            color = color.colorWithAlphaComponent(0.5)
        } else if card.shading == .Open {
            let shadingAttributes = [NSStrokeWidthAttributeName: -4,
                NSStrokeColorAttributeName: color]
            for (key, value) in shadingAttributes {
                attributes.updateValue(value, forKey: key)
            }
            color = UIColor.clearColor()
        }
        attributes[NSForegroundColorAttributeName] = color
        return NSAttributedString(string: text, attributes: attributes)
    }
}
