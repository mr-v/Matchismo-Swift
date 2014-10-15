//
//  FitToBoundsFlowLayout.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 15/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

//
//  FitItemsToBoundsFlowLayout.swift
//  SuperCardSwift
//
//  Created by Witold Skibniewski on 14/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class FitToBoundsFlowLayout: UICollectionViewFlowLayout {
    let cardRatio: CGFloat

    override init() {
        cardRatio = 2 / 3
        super.init()
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }

    required init(coder aDecoder: NSCoder) {
        cardRatio = CGFloat(aDecoder.decodeFloatForKey("cardRatio"))
        super.init(coder: aDecoder)
    }

    override func collectionViewContentSize() -> CGSize {
        return collectionView!.bounds.size
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        itemSize = sizeToFitCardsWithCount(collectionView!.numberOfItemsInSection(0), rectToFitIn: collectionView!.bounds)

        return super.layoutAttributesForElementsInRect(rect)
    }

    private func sizeToFitCardsWithCount(count: Int, rectToFitIn: CGRect) -> CGSize {
        var boundsWidth = rectToFitIn.width
        var boundsHeight = rectToFitIn.height

        var itemSize: CGSize!
        let isHorizontal = rectToFitIn.width / rectToFitIn.height > 1
        if isHorizontal {
            var columnCount = 1
            while true {
                let cellWidth = boundsWidth / CGFloat(columnCount)
                let cellHeight = cellWidth / cardRatio
                if cellWidth < 1 || cellHeight < 1 {
                    break
                }
                let rowCount = Int(boundsHeight / cellHeight)
                if (rowCount * columnCount >= count) {
                    itemSize = CGSize(width: Int(cellWidth), height: Int(cellHeight))
                    break
                }
                columnCount++
            }
        } else {
            var rowCount = 1
            while true {
                let cellHeight = boundsHeight / CGFloat(rowCount)
                let cellWidth = cellHeight * cardRatio
                if cellWidth < 1 || cellHeight < 1 {
                    break
                }
                let columnCount = Int(boundsWidth / cellWidth)
                if (columnCount * rowCount >= count) {
                    itemSize = CGSize(width: Int(cellWidth), height: Int(cellHeight))
                    break
                }
                rowCount++
            }
        }

        itemSize = itemSize ?? CGSize(width: 1, height: 1)
        return itemSize
    }
}