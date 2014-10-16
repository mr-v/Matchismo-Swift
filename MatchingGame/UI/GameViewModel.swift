//
//  GameViewModel.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

private struct GameStatistics: Equatable {
    enum StatisticsComparisonResult {
        case FlippedBackACard
        case FlippedUpACard
        case Match
        case Mismatch
    }
    var currentlyChosen: [Int] = [Int]() {
        didSet { numberOfChosenCards = currentlyChosen.count }
    }
    var numberOfChosenCards: Int = 0
    var score: Int = 0
    var numberOfMatchedCards: Int = 0

    func compare(newStats: GameStatistics) -> StatisticsComparisonResult {
        if numberOfMatchedCards == newStats.numberOfMatchedCards {
            if numberOfChosenCards == newStats.numberOfChosenCards {
                return .FlippedUpACard
            } else if score == newStats.score {
                return .FlippedBackACard
            } else {
                return .Mismatch
            }
        } else {
            return .Match
        }
    }
}

private func == (lhs: GameStatistics, rhs: GameStatistics) -> Bool {
    return lhs.score == rhs.score && lhs.numberOfChosenCards == rhs.numberOfChosenCards && lhs.numberOfMatchedCards == rhs.numberOfMatchedCards
}

class GameViewModel {
    var game: MatchingGame
    var scoreText: String {
        get { return "Score: \(game.score)" }
    }
    var numberOfCards: Int {
        get { return game.numberOfCards }
    }
    private var lastActionStatistics: GameStatistics

    init(game: MatchingGame) {
        self.game = game
        lastActionStatistics = GameStatistics()
    }

    func chooseCardWithNumber(number: Int) -> CardChoiceResult<NSIndexPath> {
        lastActionStatistics = currentStatistics()
        lastActionStatistics.currentlyChosen.append(number)
        let results = game.chooseCardWithNumber(number)
        return mapResultsToIndexPathsResults(results)
    }

    func mapResultsToIndexPathsResults(results: CardChoiceResult<Int>) -> CardChoiceResult<NSIndexPath> {
        func mapToIndexPath(numbers: [Int]) -> [NSIndexPath] {
            return numbers.map { NSIndexPath(forItem: $0, inSection: 0) }
        }

        return CardChoiceResult(unchosen: mapToIndexPath(results.unchosen), matched: mapToIndexPath(results.matched), added: mapToIndexPath(results.added))
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
        lastActionStatistics = GameStatistics()
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

    private func currentStatistics() -> GameStatistics {
        var stats = GameStatistics()
        stats.currentlyChosen = game.chosenCardsIndexes.keys.array
        stats.score = game.score
        stats.numberOfMatchedCards = game.matchedCardsIndexes.count
        return stats
    }
}