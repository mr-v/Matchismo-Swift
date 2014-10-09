//
//  DeckTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 27/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

class DeckTests: XCTestCase {
    let playingCardDeckCapacity = 52

    func test_PlayingCardFullDeck_AfterInitialization_HasSpecifiedNumberOfPlayingCards() {
        let deck: Deck = PlayingCardFullDeckBuilder().build()

        playingCardDeckCapacity.times { let card = deck.drawElement() }

        let outOfDeckBoundsElement = deck.drawElement()
        let outOfBounds = outOfDeckBoundsElement == nil
        XCTAssertTrue(outOfBounds, "")
    }

    func test_PlayingCardFullDeck_AfterInitialization_HasUniquePlayingCards() {
        let deck: Deck = PlayingCardFullDeckBuilder().build()

        var allCardsAreUnique = true
        var storeForCards = [PlayingCard: Bool]()
        for i in 1...playingCardDeckCapacity {
            let card = deck.drawElement()
            if let hasThisCard = storeForCards[card] {
                allCardsAreUnique = false
                break
            } else {
                storeForCards[card] = true
            }
        }

        XCTAssertTrue(allCardsAreUnique, "")
    }

    func test_Redeal_ChangesCards() {
        func listOfCards(deck: Deck<PlayingCard>) -> [PlayingCard] {
            var cards = [PlayingCard]()
            playingCardDeckCapacity.times { cards.append(deck.drawElement()) }
            return cards
        }

        let deck: Deck = PlayingCardFullDeckBuilder().build()
        let firstDeal = listOfCards(deck)
        deck.redeal()
        let secondDeal = listOfCards(deck)

        XCTAssertNotEqual(firstDeal, secondDeal, "")
    }

}
