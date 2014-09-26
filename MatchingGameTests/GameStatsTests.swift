//
//  GameStatsTests.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest


class GameStatsTests: XCTestCase {

    func test_GameStats_WhenInitialized_HasZeroFlipCount() {
        let stats = GameStats()

        XCTAssertEqual(stats.flipCount, 0, "")
    }

    func test_incrementFlipCount_Call_IncreasesFlipCountBy1() {
        let stats = GameStats()

        stats.incrementFlipCount()

        XCTAssertEqual(stats.flipCount, 1, "")
    }

}
