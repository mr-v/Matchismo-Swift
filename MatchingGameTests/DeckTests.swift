//
//  DeckTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 27/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

class DeckTests: XCTestCase {

     func test_Deck_OnCreation_HasProperNumberOfPlayingCards() {
        let deck: Deck = Deck()

        for i in 1...deck.initialNumberOfCards {
            let card = deck.drawACard()
        }

        let isEmpty = deck.isEmpty
        XCTAssertEqual(isEmpty, true, "")
    }

    func test_Deck_OnCreation_HasUniquePlayingCards() {
        let deck: Deck = Deck()

        var allCardsAreUnique = true
        var storeForCards = [PlayingCard: Bool]()
        for i in 1...deck.initialNumberOfCards {
            let card = deck.drawACard()
            if let hasThisCard = storeForCards[card] {
                allCardsAreUnique = false
                break
            } else {
                storeForCards[card] = true
            }
        }

        XCTAssertTrue(allCardsAreUnique, "")
    }
}
