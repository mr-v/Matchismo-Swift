//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 06/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation


// defines API for matchable games
protocol Matcher {
    var numberOfCards: Int { get }
    func match(numberOfCardsToMatch:Int, chosenCardsIndexes: [Int]) -> (success: Bool, points: Int)
    func redeal()
}


struct PenaltyPointConfiguration {
    let choosePenalty: Int
    let mismatchPenalty: Int
}

struct CardChoiceResult<T> {
    let unchosen: [T]
    let matched: [T]
    let added: [T]
}

// tracks picking cards and score
class MatchingGame {
    private var matcher: Matcher
    internal private(set) var score: Int
    var numberOfCards: Int {
        get { return matcher.numberOfCards }
    }
    var numberOfCardsToMatch: Int {
        didSet {
            let gameAlreadyStarted = matchedCardsIndexes.isEmpty && chosenCardsIndexes.isEmpty && score == 0
            if !gameAlreadyStarted {
                numberOfCardsToMatch = oldValue
            }
        }
    }
    internal let pointsConfiguration: PenaltyPointConfiguration
    var chosenCardsIndexes: [Int: Bool]
    var matchedCardsIndexes: [Int: Bool]    // leave as internal - will be visible to ViewModels but hidden from application if wrapped up in a framework

    init(matcher: Matcher, configuration: PenaltyPointConfiguration, numberOfCardsToMatch: Int) {
        self.matcher = matcher
        pointsConfiguration = configuration
        self.numberOfCardsToMatch = numberOfCardsToMatch
        score = 0
        chosenCardsIndexes =  [Int: Bool]()
        matchedCardsIndexes = [Int: Bool]()
    }

    func redeal() {
        score = 0
        chosenCardsIndexes.removeAll(keepCapacity: true)
        matchedCardsIndexes.removeAll(keepCapacity: true)
        matcher.redeal()
    }

    func chooseCardWithNumber(number: Int) -> CardChoiceResult<Int> {
        if isCardMatched(number) {
            return CardChoiceResult(unchosen: [], matched: [], added: [])
        }

        flipCard(number)
        if !isCardChosen(number) {
            chosenCardsIndexes.removeValueForKey(number)
            return CardChoiceResult(unchosen: [number], matched: [], added: [])
        }

        score += pointsConfiguration.choosePenalty
        chosenCardsIndexes[number] = true

        let enoughCardsToCheckMatch = chosenCardsIndexes.count == numberOfCardsToMatch
        if !enoughCardsToCheckMatch {
            return CardChoiceResult(unchosen: [], matched: [], added: [])
        }

        let (success, points) = matcher.match(numberOfCardsToMatch, chosenCardsIndexes: chosenCardsIndexes.keys.array)
        var matched = [Int]()
        var unchosen = [Int]()
        var added = [Int]()
        if success {
            score += points
            for (number, _) in chosenCardsIndexes {
                matchedCardsIndexes[number] = true
                matched.append(number)
            }
            chosenCardsIndexes.removeAll(keepCapacity: true)
        } else {
            matched.append(number)
            unchosen = Array(dropLast(chosenCardsIndexes.keys.array))

            score += pointsConfiguration.mismatchPenalty
            chosenCardsIndexes.removeAll(keepCapacity: true)
            chosenCardsIndexes[number] = true
        }
        return CardChoiceResult(unchosen: unchosen, matched: matched, added: added)
    }

    func isCardChosen(number: Int) -> Bool {
        return chosenCardsIndexes[number] != nil
    }

    func isCardMatched(number: Int) -> Bool {
        return matchedCardsIndexes[number] != nil
    }

    private func flipCard(number: Int) {
        if isCardChosen(number) {
            chosenCardsIndexes.removeValueForKey(number)
        } else {
            chosenCardsIndexes[number] = true
        }
    }
}