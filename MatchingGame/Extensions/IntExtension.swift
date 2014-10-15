//
//  IntExtension.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 03/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

extension Int {
    func times(f: () -> () ) {
        for _ in 0..<self {
            f()
        }
    }

    func times(f: (Int) -> ()) {
        for i in 0..<self {
            f(i)
        }
    }

    func upto(n: Int, f: (Int) -> () ) {
        for i in self...n {
            f(i)
        }
    }
    func downto(n: Int, f: (Int) -> () ) {
        for i in reverse(n...self) {
            f(i)
        }
    }
}
