//
//  CardView.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 15/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardView: UIView  {
    var enabled: Bool = true {
        didSet {
            alpha = enabled ? 1 : 0.6
            userInteractionEnabled = enabled
            setNeedsDisplay()
        }
    }
    let cornerFontStandardHeight: CGFloat = 180.0
    let cornerRadius: CGFloat = 12.0
    var cornerScaleFactor: CGFloat { return bounds.height / cornerFontStandardHeight }
    var scaledCornerRadius: CGFloat { return cornerRadius * cornerScaleFactor }
    var cornerOffset: CGFloat { return scaledCornerRadius / 3 }
    var faceCardScaleFactor: CGFloat = 0.9
    var selected: Bool = false {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        opaque = false
        backgroundColor = nil
        contentMode = .Redraw   // redraw on bounds change
    }

    let greyColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 0.8)

    override func drawRect(rect: CGRect) {
        var roundedRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: scaledCornerRadius)
        UIColor.whiteColor().setFill()
        greyColor.setStroke()
        roundedRect.fill()
        roundedRect.stroke()

        drawSymbols(rect)
    }

    func drawSymbols(rect: CGRect) {
        fatalError("\"abstract\" method \(__FUNCTION__) should be implemented in a subclass")
    }
}
