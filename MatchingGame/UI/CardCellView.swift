//
//  CardCell.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 29/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
class CardViewCell: UICollectionViewCell {
    var cardView: CardView? {
        didSet { backgroundView = cardView }
    }
    var cardBackgroundView: UIView? {
        didSet {
            if !selected {
                if let background = cardBackgroundView {
                    backgroundView = background
                }
            }
        }
    }
    override var selected: Bool {
        didSet {
            cardView?.selected = selected
            if let background = cardBackgroundView {
                let to = selected ? cardView! : background
                let options: UIViewAnimationTransition = selected ? .FlipFromLeft : .FlipFromRight
                let time = selected ? 0.2 : 0.4

                backgroundView = to
                UIView.beginAnimations(nil, context:nil)
                UIView.setAnimationDuration(time)
                UIView.setAnimationTransition(options, forView:self, cache:true)
                UIView.setAnimationDuration(time)
                UIView.commitAnimations()
            }
        }
    }
    var enabled: Bool = true {
        didSet {
            userInteractionEnabled = enabled
            cardView?.enabled = enabled
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        userInteractionEnabled = true
        cardView = nil
        cardBackgroundView = nil
    }

    //    override func prepareForInterfaceBuilder() {
    //        let view = PlayingCardView(suit: "♠", rank: "3")
    //        cardView = view
    //        selected = true
    //    }
}
