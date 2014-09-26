//
//  CardViewModel.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class CardViewModel {
    private let gameStats: GameStats

    init(gameStats stats: GameStats) {
        gameStats = stats
    }

    func flipCountText() -> String {
        return "Flips: \(String(gameStats.flipCount))"
    }

    // MARK: "port"/delegated methods

    func incrementFlipCount() {
        gameStats.incrementFlipCount();
    }
}