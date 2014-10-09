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

    init(matchable: PlayingCardMatcher) {
        matcher = matchable
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
