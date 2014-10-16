//
//  SetCardMatcherTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 09/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

class SetCardMatcherTests: XCTestCase {
    let numberOfCardsToMatch = 3

    func test_SetCardMatcher_Created_HasTwelveCards() {
        let matcher = makeSetCardMatcher()
        let expected = 12

        let cardCount = matcher.numberOfCards
        XCTAssertEqual(cardCount, expected)
    }

    func test_match_AllHaveSameNumbers_EverythingOtherDiffers_IsAMatch() {
        let matcher = makeSetCardMatcher(matchingCardsWithSameNumbers)

        let result = matcher.match(numberOfCardsToMatch, chosenCardsIndexes: [0, 1, 2])

        switch result {
        case .Success(_, _):
            XCTAssert(true)
        case .Mismatch:
            XCTFail()
        }
    }

    func test_match_AllHaveSameNumbers_TwoMatchingSymbols_NotAMatch() {
        let matcher = makeSetCardMatcher(mismatchTwoMatchingSymbols)

        let result = matcher.match(numberOfCardsToMatch, chosenCardsIndexes: [0, 1, 2])

        XCTAssertEqual(result, MatchResult.Mismatch)
    }

    func test_match_Match_ReturnsRewardPoints() {
        let matcher = makeSetCardMatcher(matchingCardsWithSameNumbers)
        let expected = matchReward

        let result = matcher.match(numberOfCardsToMatch, chosenCardsIndexes: [0, 1, 2])
        var rewardPoints: Int!

        switch result {
        case .Success(let points, _):
            rewardPoints = points
        default:
            rewardPoints = nil
        }
        XCTAssertEqual(rewardPoints, expected)
    }

    func test_match_Mismatch_ReturnsMismatchResultWithNoPoints() {
        let matcher = makeSetCardMatcher(mismatchTwoMatchingSymbols)

        let result = matcher.match(numberOfCardsToMatch, chosenCardsIndexes: [0, 1, 2])

        XCTAssertEqual(result, MatchResult.Mismatch)
    }
}

let matchingCardsWithSameNumbers = [SetCard(number: .One, symbol: .Diamond, shading: .Solid, color: .Red),
    SetCard(number: .One, symbol: .Oval, shading: .Striped, color: .Green),
    SetCard(number: .One, symbol: .Squiggle, shading: .Open, color: .Purple)]

let mismatchTwoMatchingSymbols = [SetCard(number: .One, symbol: .Oval, shading: .Solid, color: .Red),
    SetCard(number: .One, symbol: .Oval, shading: .Striped, color: .Green),
    SetCard(number: .One, symbol: .Squiggle, shading: .Open, color: .Purple)]

func makeSetCardMatcher() -> SetCardMatcher {
    return makeSetCardMatcher([])
}

let matchReward = 20

func makeSetCardMatcher(cards: [SetCard]) -> SetCardMatcher {
    let deck =  !cards.isEmpty ? makeStubDeck(cards: cards) : SetCardFullDeckBuilder().build()
    return SetCardMatcher(deck: deck, matchReward: matchReward)
}