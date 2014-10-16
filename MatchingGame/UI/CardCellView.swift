//
//  CardCell.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 29/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
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

    override func prepareForInterfaceBuilder() {
//        func setCardView() -> CardView {
//            let card = SetCard(number: .Two, symbol: .Squiggle, shading: .Striped, color: .Purple)
//            let drawer = SetCardViewBuilder().buildDrawerForSetCard(card)
//            return SetCardView(drawer: drawer)
//        }
//
//        let view = setCardView()
        let view = PlayingCardView(suit: "♠", rank: "3")
        cardView = view
        selected = true
    }
}
