//
//  StackLayout.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 18/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class StackLayout: UICollectionViewLayout, UIDynamicAnimatorDelegate {
    var anchorAttachement: UIAttachmentBehavior!
    var animator: UIDynamicAnimator!
    var attachments = [UIAttachmentBehavior]()
    var layoutAttributes: [UICollectionViewLayoutAttributes]!
    lazy var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "move:")

    override func prepareForTransitionFromLayout(oldLayout: UICollectionViewLayout) {
        animator?.removeAllBehaviors()
        animator = UIDynamicAnimator(collectionViewLayout: self)
        
        let bounds = CGRect(origin: CGPointZero, size: collectionViewContentSize())
        let previousAttributes = oldLayout.layoutAttributesForElementsInRect(bounds) as [UICollectionViewLayoutAttributes]
        layoutAttributes = previousAttributes.map {
            let attributes = UICollectionViewLayoutAttributes()
            attributes.frame = $0.frame
            attributes.transform = $0.transform
            return attributes
        }
        
        collectionView?.addGestureRecognizer(pan)
    }

    override func prepareLayout() {
        if !animator.behaviors.isEmpty {
            return
        }
       
        for (index, attributes) in enumerate(layoutAttributes) {
            let dynamicAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: index, inSection: 0))
            dynamicAttributes.frame = attributes.frame
            layoutAttributes[index] = dynamicAttributes
            let snap = UISnapBehavior(item: dynamicAttributes, snapToPoint: center())
            animator.addBehavior(snap)
        }
    }

    override func prepareForTransitionToLayout(newLayout: UICollectionViewLayout!) {
        collectionView?.removeGestureRecognizer(pan)
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return animator.itemsInRect(rect)
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return animator.layoutAttributesForCellAtIndexPath(indexPath)
    }

    override func collectionViewContentSize() -> CGSize {
        return collectionView!.bounds.size
    }

    func center() -> CGPoint {
        let size = collectionViewContentSize()
        return CGPoint(x: size.width/2, y: size.height/2)
    }

    func move(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            attachments.removeAll(keepCapacity: true)
            animator.removeAllBehaviors()

            let itemBehavior = UIDynamicItemBehavior()
            itemBehavior.density = 0
            animator.addBehavior(itemBehavior)
            
            let lastAttribute = last(layoutAttributes)!
            itemBehavior.addItem(lastAttribute)
            anchorAttachement = UIAttachmentBehavior(item: lastAttribute, attachedToAnchor: recognizer.locationInView(collectionView))
            animator.addBehavior(anchorAttachement)
            attachments.append(anchorAttachement)

            let count = collectionView!.numberOfItemsInSection(0)
            for i in 0..<count-2 {
                let current = layoutAttributes[i]
                itemBehavior.addItem(current)
                let attach = UIAttachmentBehavior(item: current, attachedToItem: lastAttribute)
                animator.addBehavior(attach)
                attachments.append(attach)
            }
        case .Changed:
            anchorAttachement.anchorPoint = recognizer.locationInView(collectionView)
//            let item = anchorAttachement.items[0] as UICollectionViewLayoutAttributes
//            let attributes = layoutAttributesForItemAtIndexPath(item.indexPath)
//            attributes.center = recognizer.locationInView(collectionView)
//            animator.updateItemUsingCurrentState(attributes)
        case .Ended:
//            let topItem = attachments[0].items[0] as UIDynamicItem
            let v = recognizer.velocityInView(collectionView)

            for behavior in attachments {   //  as [UIAttachmentBehavior]
                let item = behavior.items[0] as UIDynamicItem
                let push = UIPushBehavior(items: [item], mode: UIPushBehaviorMode.Instantaneous)
                push.pushDirection = CGVectorMake(v.x/200, v.y/200)
                animator.addBehavior(push)

//                let snap = UISnapBehavior(item: item, snapToPoint: center())
//                animator.addBehavior(snap)
                animator.removeBehavior(behavior)
            }

            let closureAttachments = attachments
            let distance = sqrt(v.x * v.x + v.y * v.y)
            let time = distance / 20000
            delay(Double(time)) {
                for behavior in closureAttachments {
                    let item = behavior.items[0] as UIDynamicItem
                    let snap = UISnapBehavior(item: item, snapToPoint: self.center())
                    self.animator.addBehavior(snap)
                }
            }
            attachments.removeAll()
            animator.removeBehavior(anchorAttachement)
            anchorAttachement = nil
        default:
            false
        }
    }
}
