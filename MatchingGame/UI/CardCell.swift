//
//  CardCell.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 29/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

class CardViewCell: UICollectionViewCell {
    var cardView: CardView? {
        didSet {
            backgroundView = cardView
        }
    }
    override var selected: Bool {
        didSet { cardView?.selected = selected }
    }
    var enabled: Bool = true {
        didSet {
            cardView?.enabled = enabled
        }
    }
}
