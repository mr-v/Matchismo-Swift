//
//  GameViewModel.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

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
    private let printer:CardSymbolPrinter

    init(game: MatchingGame, printer: CardSymbolPrinter) {
        self.game = game
        self.printer = printer
        lastActionStatistics = GameStatistics()
    }

    func textForCardWithNumber(number: Int) -> NSAttributedString {
        return printer.attributtedStringForCardWithNumber(number)
    }

    func chooseCardWithNumber(number: Int) {
        lastActionStatistics = currentStatistics()
        lastActionStatistics.currentlyChosen.append(number)
        game.chooseCardWithNumber(number)

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

    func lastActionText() -> NSAttributedString {
        var text: NSAttributedString!
        let currentStats = currentStatistics()
        let lastAction = lastActionStatistics.compare(currentStats)
        switch lastAction {
        case .FlippedBackACard, .FlippedUpACard:
            text  = cardDescriptionsForIndexes(currentStats.currentlyChosen)
        case .Match:
            let cardDescriptions = cardDescriptionsForIndexes(lastActionStatistics.currentlyChosen)
            let points = currentStats.score - lastActionStatistics.score - game.pointsConfiguration.choosePenalty
            let mutable = NSMutableAttributedString(string: "Matched ")
            mutable.appendAttributedString(cardDescriptions)
            mutable.appendAttributedString(NSAttributedString(string: " for \(points)"))
            text = mutable
        case .Mismatch:
            let cardDescriptions = cardDescriptionsForIndexes(lastActionStatistics.currentlyChosen)
            let points = abs(currentStats.score - lastActionStatistics.score - game.pointsConfiguration.choosePenalty)
            let mutable = NSMutableAttributedString(attributedString: cardDescriptions)
            mutable.appendAttributedString(NSAttributedString(string: " don't match! \(points) points penalty!"))
            text = mutable

        default:
            fatalError("missing case")
        }
        return text
    }

    func isCardMatched(number: Int) -> Bool {
        return game.isCardMatched(number)
    }

    func isCardChosen(number: Int) -> Bool {
        return game.isCardChosen(number)
    }

    private func cardDescriptionsForIndexes(indexes: [Int]) -> NSAttributedString {
        let descriptions = indexes.map{ self.printer.attributtedStringForCardWithNumber($0) }
        let text = NSMutableAttributedString()
        for (index, d) in enumerate(descriptions) {
            text.appendAttributedString(d)
            if index < descriptions.count - 1 {
                text.appendAttributedString(NSAttributedString(string: ", "))
            }
        }
        return text
    }

    private func currentStatistics() -> GameStatistics {
        var stats = GameStatistics()
        stats.currentlyChosen = game.chosenCardsIndexes.keys.array
        stats.score = game.score
        stats.numberOfMatchedCards = game.matchedCardsIndexes.count
        return stats
    }
}