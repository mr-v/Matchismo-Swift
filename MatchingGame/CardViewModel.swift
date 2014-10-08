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


class CardViewModel {
    var game: MatchingGame

    var scoreText: String {
        get { return "Score: \(game.score)" }
    }
    var numberOfCards: Int {
        get { return game.numberOfCards }
    }
    private var lastActionStatistics: GameStatistics

    init(game: PlayingCardMatchingGame) {
        self.game = game
        lastActionStatistics = GameStatistics()
    }

    func textForCardWithNumber(number: Int) -> String {
        return game.printableForCardWithNumber(number).description
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
        game = PlayingCardMatchingGame(configuration: game.pointsConfiguration, numberOfCards: numberOfCards, numberOfCardsToMatch: game.numberOfCardsToMatch)
        lastActionStatistics = GameStatistics()
    }

    func changeModeWithNumberOfCardsToMatch(count: Int) {
        game.numberOfCardsToMatch = count
    }

    func lastActionText() -> String {
        var text: String!
        let currentStats = currentStatistics()
        let lastAction = lastActionStatistics.compare(currentStats)
        switch lastAction {
        case .FlippedBackACard, .FlippedUpACard:
            text  = cardDescriptionsForIndexes(currentStats.currentlyChosen)
        case .Match:
            let cardDescriptions = cardDescriptionsForIndexes(lastActionStatistics.currentlyChosen)
            let points = currentStats.score - lastActionStatistics.score + game.pointsConfiguration.choosePenalty
            text = "Matched \(cardDescriptions) for \(points)"
        case .Mismatch:
            let cardDescriptions = cardDescriptionsForIndexes(lastActionStatistics.currentlyChosen)
            let points = abs(currentStats.score - lastActionStatistics.score + game.pointsConfiguration.choosePenalty)
            text = "\(cardDescriptions) don't match! \(points) points penalty!"
        default:
            fatalError("missing case")
        }
        return text
    }

    func isCardMatched(number: Int) -> Bool {
        return game.matchedCardsIndexes[number] != nil
    }

    func isCardChosen(number: Int) -> Bool {
        return game.isCardChosen(number)
    }

    private func cardDescriptionsForIndexes(indexes: [Int]) -> String {
        let descriptions = indexes.map{ self.game.printableForCardWithNumber($0).description }
        return ", ".join(descriptions)
    }

    private func currentStatistics() -> GameStatistics {
        var stats = GameStatistics()
        stats.currentlyChosen = game.chosenCardsIndexes.keys.array
        stats.score = game.score
        stats.numberOfMatchedCards = game.matchedCardsIndexes.count
        return stats
    }
}