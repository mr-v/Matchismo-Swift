//
//  PlayingCardSymbolDrawerBuilder.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 15/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PlayingCardViewBuilder: CardViewBuilder {
    private let letterMapping: [Rank: String] = [.Ace: "A", .Jack: "J", .Queen: "Q", .King: "K"]
    private let matcher: PlayingCardMatcher

    init(matcher: PlayingCardMatcher) {
        self.matcher = matcher
    }

    func viewForCardWithNumber(number: Int) -> CardView {
        let card = matcher.cardWithNumber(number)
        let suit = card.suit.rawValue
        let rank = letterMapping[card.rank] ?? String(card.rank.rawValue)
        return PlayingCardView(suit: suit, rank: rank)
    }

    func backgroundView() -> UIView? {
        return PlayingCardBackView(frame: CGRectZero)
    }
}

