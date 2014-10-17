//
//  FitToBoundsFlowLayout.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 15/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

//
//  FitItemsToBoundsFlowLayout.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 14/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class FitToBoundsFlowLayout: UICollectionViewFlowLayout {
    let cardRatio: CGFloat
    var insertItems = NSMutableSet()
    var deleteItems = NSMutableSet()
    var reloading = false

    override init() {
        cardRatio = 2 / 3
        super.init()
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }

    required init(coder aDecoder: NSCoder) {
        cardRatio = CGFloat(aDecoder.decodeFloatForKey("cardRatio"))
        insertItems = NSMutableSet()
        deleteItems = NSMutableSet()
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

    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)
        let items = updateItems as [UICollectionViewUpdateItem]
        for item in items {
            switch item.updateAction {
            case .Insert:
                insertItems.addObject(item.indexPathAfterUpdate.item)
            case .Delete:
                deleteItems.addObject(item.indexPathBeforeUpdate.item)
            case .Reload:
                reloading = true
            default:
                let uncustomizedAction = true
            }
        }
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        insertItems.removeAllObjects()
        deleteItems.removeAllObjects()
        reloading = false
    }

    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)!
        attributes.alpha = 1
        let bounds = collectionView!.bounds
        if insertItems.containsObject(itemIndexPath.item) {
            attributes.center = CGPoint(x: bounds.midX, y: bounds.maxY)
        } else if reloading {
            attributes.center = attributes.center.pointByOffsetting(0, dy: bounds.height)
        }
        return attributes
    }

    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)!
        if deleteItems.containsObject(itemIndexPath.item) || reloading {
            let bounds = collectionView!.bounds
            attributes.center =  attributes.center.pointByOffsetting(0, dy: -bounds.height * 2)
            attributes.alpha = 1
            attributes.zIndex = 1
        }
        return attributes
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