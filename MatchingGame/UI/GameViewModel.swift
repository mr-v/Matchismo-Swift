//
//  GameViewModel.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class GameViewModel {
    var game: MatchingGame
    var scoreText: String {
        get { return "Score: \(game.score)" }
    }
    var numberOfCards: Int {
        get { return game.numberOfCards }
    }
    init(game: MatchingGame) {
        self.game = game
    }

    func chooseCardWithNumber(number: Int) -> CardChanges<NSIndexPath> {
        let results = game.chooseCardWithNumber(number)
        return mapResultsToIndexPathsResults(results)
    }

    func mapResultsToIndexPathsResults(results: CardChanges<Int>) -> CardChanges<NSIndexPath> {
        func mapToIndexPath(numbers: [Int]) -> [NSIndexPath] {
            return numbers.map { NSIndexPath(forItem: $0, inSection: 0) }
        }

        return CardChanges(unchosen: mapToIndexPath(results.unchosen), matched: mapToIndexPath(results.matched), added: mapToIndexPath(results.added))
    }

    func currentlyAvailableCardsNumbers() -> [Int] {
        var numbers = [Int]()
        let cardsCount = numberOfCards
        for i in 0..<cardsCount {
            if !game.isCardChosen(i) && !isCardMatched(i)  {
                numbers.append(i)
            }
        }
        return numbers
    }

    func redeal() {
        game.redeal()
    }

    func changeModeWithNumberOfCardsToMatch(count: Int) {
        game.numberOfCardsToMatch = count
    }

    func isCardMatched(number: Int) -> Bool {
        return game.isCardMatched(number)
    }

    func isCardChosen(number: Int) -> Bool {
        return game.isCardChosen(number)
    }
}