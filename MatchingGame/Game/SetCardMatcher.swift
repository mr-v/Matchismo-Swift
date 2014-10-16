//
//  SetGameMatcher.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 09/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class SetCardMatcher: Matcher {
    let initialNumberOfCards = 12
    private var cards: [SetCard]
    private let matchReward: Int
    var numberOfCards: Int { return cards.count }
    var deck:Deck<SetCard>

    init(deck: Deck<SetCard>, matchReward: Int) {
        self.deck = deck
        self.matchReward = matchReward
        cards = deck.drawElementsWithCount(initialNumberOfCards)
    }

    func match(numberOfCardsToMatch: Int, chosenCardsIndexes: [Int]) -> (success: Bool, points: Int) {
        var numberMatches = [SetNumber: Int]()
        var symbolMatches = [SetSymbol: Int]()
        var shadingMatches = [SetShading: Int]()
        var colorMatches = [SetColor: Int]()

        for i in chosenCardsIndexes {
            let card = cards[i]
            numberMatches[card.number] = numberMatches[card.number]?.advancedBy(1) ?? 1
            symbolMatches[card.symbol] = symbolMatches[card.symbol]?.advancedBy(1) ?? 1
            shadingMatches[card.shading] = shadingMatches[card.shading]?.advancedBy(1) ?? 1
            colorMatches[card.color] = colorMatches[card.color]?.advancedBy(1) ?? 1
        }
        let maxMatches = [maxElement(numberMatches.values), maxElement(symbolMatches.values), maxElement(shadingMatches.values), maxElement(colorMatches.values)]
        let matches = maxMatches.reduce(true) { acc, matchCount in acc && (matchCount == 3 || matchCount == 1) }

        if matches {
            removeCardsWithNumbers(chosenCardsIndexes)
        }

        let points = matches ? matchReward : 0
        return (matches, points)
    }

    func redeal() {
        deck.redeal()
        cards = deck.drawElementsWithCount(initialNumberOfCards)
    }

    func cardWithNumber(number: Int) -> SetCard {
        return cards[number]
    }

    //MARK: -

    func removeCardsWithNumbers(numbers: [Int]) {
        for (index, number) in enumerate(numbers) {
            cards.removeAtIndex(number - index)
        }
    }
}