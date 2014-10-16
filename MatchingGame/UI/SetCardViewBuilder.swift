//
//  SetCardBuilder.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 14/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class SetCardViewBuilder: CardViewBuilder
 {
    let matcher: SetCardMatcher?

    init(matcher: SetCardMatcher?) {
        self.matcher = matcher
    }

    func viewForCardWithNumber(number: Int) -> CardView {
        let card = matcher!.cardWithNumber(number)
        let drawer = buildDrawerForSetCard(card)
        return SetCardView(drawer: drawer)
    }

    func buildDrawerForSetCard(card: SetCard) -> SetCardSymbolDrawingClosure {
        var shadingColor: UIColor = colorForSetColor(card.color)
        var setupShading = shadingSetupForShading(card.shading, shadingColor: shadingColor)
        var drawSymbol = drawerForSymbol(card.symbol)

        func draw(center: CGPoint, bounds: CGRect) {
            var offsets: [(CGFloat, CGFloat)]!
            switch card.number {
            case .One:
                offsets = [(0, 0)]
            case .Two:
                offsets = [(0, -bounds.height/8), (0, bounds.height/8)]
            case .Three:
                offsets = [(0, 0), (0, -bounds.height/4), (0, bounds.height/4)]
            }

            var symbolAnchors: [CGPoint] = offsets.map { (x, y) in center.pointByOffsetting(x, dy: y)}
            setupShading()
            for point in symbolAnchors {
                drawSymbol(center: point, bounds: bounds)
            }
        }
        return draw
    }

    private func colorForSetColor(color: SetColor) -> UIColor {
        switch color {
        case .Red:
            return UIColor.redColor()
        case .Green:
            return UIColor.greenColor()
        case .Purple:
            return UIColor.purpleColor()
        }
    }

    private func shadingSetupForShading(shading: SetShading, shadingColor: UIColor) -> () -> () {
        var shadingSetup: (() -> ())!
        switch shading {
        case .Open:
            shadingSetup = {
                UIColor.whiteColor().setFill()
                shadingColor.setStroke()
            }
        case .Solid:
            shadingSetup = {
                shadingColor.setFill()
                shadingColor.setStroke()
            }
        case .Striped:
            func coloredStripedFill(color: UIColor) -> UIColor {
                let rect = CGRect(x: 0, y: 0, width: 3, height: 1)
                UIGraphicsBeginImageContext(rect.size)
                let context = UIGraphicsGetCurrentContext()
                CGContextSetFillColorWithColor(context, color.CGColor)
                let (halfRect, _) = rect.rectsByDividing(1, fromEdge: .MinXEdge)
                CGContextFillRect(context, halfRect)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return UIColor(patternImage: image)
            }

            shadingSetup = {
                shadingColor.setStroke()
                let stripedFill = coloredStripedFill(shadingColor)
                stripedFill.setFill()
            }
        }
        return shadingSetup
    }

    func drawerForSymbol(symbol: SetSymbol) -> (center: CGPoint, bounds: CGRect) -> () {
        switch symbol {
        case .Squiggle:
            return makeDrawSquiggle()
        case .Oval:
            return makeDrawOval()
        case .Diamond:
            return makeDrawDiamond()
        }
    }

    private func makeDrawSquiggle() -> (CGPoint, CGRect) -> () {
        return { point, bounds in
            var path = UIBezierPath()

            func addCurveWithTwoControlPointWithPoints(points: [(x: CGFloat, y: CGFloat)]) {
                let points = points.map { (x, y) in CGPoint(x: x, y: y) }
                path.addCurveToPoint(points[0], controlPoint1: points[1], controlPoint2: points[2])
            }
            path.moveToPoint(CGPoint(x: 104, y: 15))
            addCurveWithTwoControlPointWithPoints([(63, 54), (112, 37), (90, 61)])
            addCurveWithTwoControlPointWithPoints([(27, 53), (52, 51), (42, 42)])
            addCurveWithTwoControlPointWithPoints([(5, 40), (10, 66), (5, 58)])
            addCurveWithTwoControlPointWithPoints([(36, 12), (5, 22), (19, 10)])
            addCurveWithTwoControlPointWithPoints([(89, 14), (59, 15), (62, 32)])
            addCurveWithTwoControlPointWithPoints([(104, 15), (95, 10), (101, 7)])

            let size = CGSize(width: bounds.width/4 , height: bounds.height/4);
            path.applyTransform(CGAffineTransformMakeScale(size.width/80, size.height/120))
            path.applyTransform(CGAffineTransformMakeTranslation(floor(point.x - size.width/1.5), floor(point.y - size.height/3)))

            path.fill()
            path.stroke()
        }
    }

    private func makeDrawOval() -> (CGPoint, CGRect) -> () {
        return { point, bounds in
            var rectToDraw = CGRectApplyAffineTransform(bounds, CGAffineTransformMakeScale(1/3, 1/10))
            rectToDraw.origin = point.pointByOffsetting(-rectToDraw.width/2, dy: -rectToDraw.height/2)
            rectToDraw.integerize()

            var path = UIBezierPath(roundedRect:rectToDraw, cornerRadius: 100)

            path.fill()
            path.stroke()
        }
    }

    private func makeDrawDiamond() -> (CGPoint, CGRect) -> () {
        return { point, bounds in
            var rectToDraw = CGRectApplyAffineTransform(bounds, CGAffineTransformMakeScale(1/3, 1/10))
            rectToDraw.origin = point.pointByOffsetting(-rectToDraw.width/2, dy: -rectToDraw.height/2)
            rectToDraw.integerize()

            var path = UIBezierPath()
            path.moveToPoint(CGPoint(x: rectToDraw.minX, y: rectToDraw.midY))
            let coords: [(x: CGFloat, y: CGFloat)] = [(rectToDraw.midX, rectToDraw.minY), (rectToDraw.maxX, rectToDraw.midY), (rectToDraw.midX, rectToDraw.maxY)]
            for c in coords { path.addLineToPoint(CGPoint(x: round(c.x), y: round(c.y))) }
            path.closePath()
            
            path.fill()
            path.stroke()
        }
    }
}

