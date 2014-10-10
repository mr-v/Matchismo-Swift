//
//  CardCell.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 29/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardViewCell: UICollectionViewCell {
    @IBInspectable var cardFace: UIImage! {
        didSet { selectedBackgroundView = UIImageView(image: cardFace)}
    }
    @IBInspectable var cardBack: UIImage! {
        didSet { backgroundView = UIImageView(image: cardBack)}
    }
    @IBOutlet var title: UILabel! {
        didSet { title.hidden = true }
    }
    override var selected: Bool {
        didSet { title?.hidden = !selected }
    }
    var enabled: Bool = true {
        didSet {
            userInteractionEnabled = enabled
            alpha = enabled ? 1 : 0.6
        }
    }
}

@IBDesignable class NonFlippingCardViewCell: CardViewCell {
    @IBOutlet override var title: UILabel! {
        didSet { title.hidden = false }
    }
    override var selected: Bool {
        didSet {
            title?.hidden = false
            selectedBackgroundView.layer.borderColor = UIColor.orangeColor().CGColor
            selectedBackgroundView.layer.borderWidth = selected ? 2 : 0
        }
    }
}