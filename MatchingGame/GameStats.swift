//
//  GameStats.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

public class GameStats {
    public private(set) var flipCount: Int = 0

    func incrementFlipCount() {
        flipCount++;
    }

}