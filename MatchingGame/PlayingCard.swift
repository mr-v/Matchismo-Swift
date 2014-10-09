//
//  Deck.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 27/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

// MARK: - Playing Card

enum Suit: String {
    case Hearts = "♥"
    case Spades = "♠"
    case Diamonds = "♦"
    case Clubs = "♣"
}

enum Rank: Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
}

struct PlayingCard: Hashable {
    let suit: Suit
    let rank: Rank

    init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }

    var hashValue: Int {
        return (String(rank.rawValue) + suit.rawValue).hashValue
    }
}

// To conform to the protocol, you must provide an operator declaration for == at global scope
func == (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
    return lhs.suit == rhs.suit && lhs.rank == rhs.rank
}
