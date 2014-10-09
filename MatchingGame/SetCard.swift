//
//  SetCard.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 08/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation


enum SetNumber: Int {
    case One = 1, Two, Three
}

enum SetSymbol: String {
    case Diamond = "▲"
    case Oval = "●"
    case Squiggle = "■"
}

enum SetShading {
    case Solid, Striped, Open
}

enum SetColor {
    case Red, Green, Purple
}

struct SetCard: Hashable {
    let number: SetNumber
    let symbol: SetSymbol
    let shading: SetShading
    let color: SetColor

    var hashValue: Int {
        return "\(String(number.rawValue)),\(symbol.rawValue),\(shading.hashValue),\(color.hashValue)".hashValue
    }
}

// To conform to the protocol, you must provide an operator declaration for == at global scope
func == (lhs: SetCard, rhs: SetCard) -> Bool {
    return lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading && lhs.color == rhs.color
}
