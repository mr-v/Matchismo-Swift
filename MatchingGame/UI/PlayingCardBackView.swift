//
//  PlayingCardBackView.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 16/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PlayingCardBackView: CardView {

    override func drawSymbols(rect: CGRect)
    {
        let backImage = UIImage(named: "card_back", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
        backImage!.drawInRect(bounds)
    }
}
