//
//  Deck.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 09/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class Deck<T> {
    private var elements:[T]

    private let createElements: () -> [T]

    init(createElements: () -> [T]) {
        self.createElements = createElements
        elements = [T]()
        redeal()
    }

    func drawElement() -> T! {
        if elements.isEmpty {
            return nil
        }
        return elements.removeLast()
    }

    func drawElementsWithCount(count: Int) -> [T] {
        if count > elements.count {
            fatalError("count out of bounds")
        }

        let startIndex = elements.count - count
        return drawFromRange(startIndex..<elements.count)
    }

    func drawElementsAtMost(limit: Int) -> [T] {
        let startIndex = max(elements.count - limit, 0)
        return drawFromRange(startIndex..<elements.count)
    }

    private func drawFromRange(range: Range<Int>) -> [T] {
        let elementsFromRange = reverse(elements[range])
        elements.removeRange(range)
        return elementsFromRange
    }

    func redeal() {
        elements = createElements()
        shuffle(&elements)
    }

    private func shuffle<T>(inout array: Array<T>) {
        var i = array.count
        while i > 1 {
            i -= 1
            let swapIndex = Int(arc4random_uniform(UInt32(i)))
            swap(&array[i], &array[swapIndex])
        }
    }
}


class PlayingCardFullDeckBuilder {
    private let buildClosure: () -> [PlayingCard]

    init() {
        buildClosure = {
            var cards = [PlayingCard]()
            let allSuits: [Suit] = [.Hearts, .Spades, .Diamonds, .Clubs]
            for i in Rank.Ace.rawValue...Rank.King.rawValue {
                cards += allSuits.map { PlayingCard(suit: $0, rank: Rank(rawValue: i)!) }
            }
            return cards
        }
    }

    func build() -> Deck<PlayingCard> {
        return Deck<PlayingCard>(createElements: buildClosure)
    }
}

class SetCardFullDeckBuilder {
    private let buildClosure: () -> [SetCard]

    init() {
        buildClosure = {
            var cards = [SetCard]()
            let numbers: [SetNumber] = [ .One, .Two, .Three]
            let symbols: [SetSymbol] = [ .Diamond, .Oval, .Squiggle]
            let shadings: [SetShading] = [.Solid, .Striped, .Open]
            let colors: [SetColor] = [.Red, .Green, .Purple]
            for n in numbers {
                for s in symbols {
                    for sh in shadings {
                        for c in colors {
                            cards.append(SetCard(number: n, symbol: s, shading: sh, color: c))
                        }
                    }
                }
            }
            return cards
        }
    }

    func build() -> Deck<SetCard> {
        return Deck<SetCard>(createElements: buildClosure)
    }
}

// MARK: - for stubbing purposes

class NonShufflingDeckBuilder<T> {
    private let buildClosure: () -> [T]

    init(cards: [T]) {
        buildClosure = { return reverse(cards) }    // reverse because deck draws elements from the back
    }

    func build() -> Deck<T> {
        return NonShufflingDeck<T>(createElements: buildClosure)
    }
}

class NonShufflingDeck<T> : Deck<T> {
    override init(createElements: () -> [T]) {
        super.init(createElements: createElements)
    }

    private override func shuffle<T>(inout array: Array<T>) {
    }

    override func drawElementsWithCount(count: Int) -> [T] {
        return reverse(elements[0..<elements.count])
    }
}
