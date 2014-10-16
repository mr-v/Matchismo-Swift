//
//  PlayingCardView.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 15/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PlayingCardView: CardView {
    var suit: String! {
        didSet { setNeedsDisplay() }
    }
    var rank: String! {
        didSet { setNeedsDisplay() }
    }

    init(suit: String, rank: String) {
        self.suit = suit
        self.rank = rank
        super.init(frame: CGRectZero)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawSymbols(rect: CGRect) {
        if !selected {
            // loading this way to get a live preview
            let backImage = UIImage(named: "card_back", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
            backImage!.drawInRect(bounds)
        } else {
            drawFace()
            drawTextInCorners()
        }
    }

    private func drawFace() {
        if let faceImage = UIImage(named: "\(rank)\(suit)", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil) {
            let insetScale: CGFloat = 1 - faceCardScaleFactor
            let xInset = floor(bounds.width * (1 - faceCardScaleFactor)/2)
            let yInset = floor(bounds.height * (1 - faceCardScaleFactor)/3)
            let imageRect = bounds.rectByInsetting(dx: xInset, dy: yInset)
            faceImage.drawInRect(imageRect)
        } else {
            drawPips()
        }
    }

    private func drawTextInCorners() {
        let text = NSMutableAttributedString(string: "\(rank)\n\(suit)", attributes: cornerTextAttributes())
        let size = text.size()
        let textRect = CGRect(x: cornerOffset, y: cornerOffset, width: size.width, height: size.height)
        text.drawInRect(textRect)

        rotateContextUpsideDown()
        text.drawInRect(textRect)
        popContext()
    }

    let pipHorizontalOffsetPercentage: CGFloat = 16.5/100
    let pipVerticalOffset1Percentage: CGFloat = 9/100
    let pipVerticalOffset2Percentage: CGFloat = 17.5/100
    let pipVerticalOffset3Percentage: CGFloat = 27/100

    private func drawPips() {
        if contains(["1", "3", "5", "9"], rank) {
            drawPipsWithHorizontalOffset(0, verticalOffset: 0)
        }
        if contains(["6", "7", "8"], rank) {
            drawPipsWithHorizontalOffset(pipHorizontalOffsetPercentage, verticalOffset: 0)
        }
        if contains(["2", "3", "7", "8", "10"], rank) {
            let mirror = rank != "7"
            drawPipsWithHorizontalOffset(0, verticalOffset: pipVerticalOffset2Percentage, mirroredVertically: mirror)
        }
        if contains(["4", "5", "6", "7", "8", "9", "10"], rank) {
            drawPipsWithHorizontalOffset(pipHorizontalOffsetPercentage, verticalOffset: pipVerticalOffset3Percentage, mirroredVertically: true)
        }
        if contains(["9", "10"], rank) {
            drawPipsWithHorizontalOffset(pipHorizontalOffsetPercentage, verticalOffset: pipVerticalOffset1Percentage, mirroredVertically: true)
        }
    }

    func drawPipsWithHorizontalOffset(horizontalOffset: CGFloat, verticalOffset: CGFloat, mirroredVertically: Bool) {
        drawPipsWithHorizontalOffset(horizontalOffset, verticalOffset: verticalOffset)

        if mirroredVertically {
            rotateContextUpsideDown()
            drawPipsWithHorizontalOffset(horizontalOffset, verticalOffset: verticalOffset)
            popContext()
        }
    }

    func drawPipsWithHorizontalOffset(horizontalOffset: CGFloat, verticalOffset: CGFloat) {
        let pipFontScaleFactor: CGFloat = 0.012

        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        let pipFont = bodyFont.fontWithSize(bodyFont.pointSize * pipFontScaleFactor * bounds.width)
        let attributedSuit = NSAttributedString(string: suit, attributes: [NSFontAttributeName: pipFont])
        let pipSize = attributedSuit.size()
        let x: CGFloat = bounds.midX - pipSize.width/2 - horizontalOffset * bounds.width
        let y: CGFloat = bounds.midY - pipSize.height/2 - verticalOffset * bounds.height
        var pipOrigin = CGPoint(x: x, y: y)
        attributedSuit.drawAtPoint(pipOrigin)
        if horizontalOffset != 0 {
            pipOrigin.x += 2 * horizontalOffset * bounds.width
            attributedSuit.drawAtPoint(pipOrigin)
        }
    }

    func rotateContextUpsideDown() {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, bounds.width, bounds.height)
        CGContextRotateCTM(context, CGFloat(M_PI))
    }

    func popContext() {
        CGContextRestoreGState(UIGraphicsGetCurrentContext())
    }

    private func cornerTextAttributes() -> [NSObject: AnyObject] {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        let resized = bodyFont.fontWithSize(bodyFont.pointSize * cornerScaleFactor)

        return [NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: resized]
    }

    override func prepareForInterfaceBuilder() {
        setup()
        
        rank = "Q"
        suit = "♦"
    }
}
