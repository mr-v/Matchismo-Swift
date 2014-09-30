//
//  CardViewModel.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

// MARK: Extensions

extension PlayingCard: Printable {
    var description: String {
        get {
            let letterMapping: [Rank: String] = [.Ace: "A", .Jack: "J", .Queen: "Q", .King: "K"]

            var rankText: String
            switch letterMapping[rank] {
            case nil:
                rankText = String(rank.rawValue)
            case let mappedText:
                rankText = mappedText!
            }
            let s = suit.rawValue
            return rankText + s
        }
    }
}

// MARK:

class CardViewModel {
    private let game: MatchingGame

    var scoreText: String {
        get { return "Score: \(game.score)" }
    }
    var matchedCardNumbers: [Int] {
        get { return game.matchedCardsIndexes.keys.array }
    }
    var numberOfCards: Int {
        get { return game.numberOfCards }
    }

    init(game: MatchingGame) {
        self.game = game
    }

    func textForCardWithNumber(number: Int) -> String {
        return game.cardWithNumber(number).description
    }

    func chooseCardWithNumber(number: Int) {
        game.chooseCardWithNumber(number)
    }

    func currentlyAvailableCardsNumbers() -> [Int] {
        var numbers = [Int]()
        let cards = game.cards
        for i in 0..<cards.count {
            let card = cards[i]
            if !card.chosen {
                numbers.append(i)
            }
        }
        return numbers
    }
}