//
//  Deck.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 27/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

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
    var chosen: Bool

    init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
        chosen = false
    }

    var hashValue: Int {
        return (String(rank.rawValue) + suit.rawValue).hashValue
    }

    mutating func flip() {
        chosen = !chosen
    }
}

// To conform to the protocol, you must provide an operator declaration for == at global scope
func == (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
    return lhs.suit == rhs.suit && lhs.rank == rhs.rank
}


class Deck {
    var isEmpty: Bool {
        get {
            return cards.isEmpty
        }
    }
    private var cards: [PlayingCard]
    internal let initialNumberOfCards = 52

    init() {
        cards = [PlayingCard]()

        let allSuits: [Suit] = [.Hearts, .Spades, .Diamonds, .Clubs]
        for i in Rank.Ace.rawValue...Rank.King.rawValue {
            cards += allSuits.map { PlayingCard(suit: $0, rank: Rank(rawValue: i)!) }
        }
    }

    func drawACard() -> PlayingCard! {
        if isEmpty {
            return nil
        }

        let index = arc4random_uniform(CUnsignedInt(cards.count))
        return cards.removeAtIndex(Int(index))
    }
}