//
//  SetCardView.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 15/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

typealias SetCardSymbolDrawingClosure = (point:CGPoint, bounds:CGRect) -> ()

class SetCardView: CardView {
    override var selected: Bool {
        didSet {
            layer.borderColor = UIColor.orangeColor().CGColor
            layer.borderWidth = selected && enabled ? 2 : 0
        }
    }
    var drawer: SetCardSymbolDrawingClosure!

    init(drawer: SetCardSymbolDrawingClosure) {
        self.drawer = drawer
        super.init(frame: CGRectZero)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawSymbols(rect: CGRect) {
        drawer(point: center, bounds: rect)
    }
}
