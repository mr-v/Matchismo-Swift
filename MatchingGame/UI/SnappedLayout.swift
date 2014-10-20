//
//  SnappedLayout.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 18/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class SnappedLayout: UICollectionViewLayout, UIDynamicAnimatorDelegate {
    var animator: UIDynamicAnimator!
    lazy var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "move:")
    var snapped: Bool = false
    var attachments = [UIAttachmentBehavior]()

    var layoutAttributes: [UICollectionViewLayoutAttributes]!

    override func prepareForTransitionFromLayout(oldLayout: UICollectionViewLayout) {
        animator?.removeAllBehaviors()
        animator = UIDynamicAnimator(collectionViewLayout: self)

        let rect = CGRect(origin: CGPointZero, size: collectionViewContentSize())
        layoutAttributes = oldLayout.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        snapped = true
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

    //    func unfold() {
    //        snapped = false
    //        for behavior in animator.behaviors {
    //            if let snap = behavior as? UISnapBehavior {
    //                animator.removeBehavior(snap)
    //            }
    //        }
    //        for i in 0..<collectionView!.numberOfItemsInSection(0) {
    //            let attributes = super.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
    //            let snap = UISnapBehavior(item: attributes, snapToPoint: attributes.center)
    //            animator.addBehavior(snap)
    //        }
    //        animator.delegate = self
    //        //        animator.removeAllBehaviors()
    //        //        animator = nil
    //        //        self.collectionView?.addGestureRecognizer(self.pinch)
    //    }
    //
    //    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
    //        animator.delegate = nil
    //        animator.removeAllBehaviors()
    //    }

    func move(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            attachments.removeAll(keepCapacity: true)
            animator.removeAllBehaviors()

            let count = collectionView!.numberOfItemsInSection(0)
//            var last = layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: count - 1, inSection: 0))!
            var last = layoutAttributes[count-1]
            last.center = center()
            last.zIndex = 1
            let attachment = UIAttachmentBehavior(item: last, attachedToAnchor: center())
            animator.addBehavior(attachment)
            attachments.append(attachment)

            for i in reverse(1..<count-2) {
//                let path = NSIndexPath(forRow: i, inSection: 0)
//                let current = layoutAttributesForItemAtIndexPath(path)
                let current = layoutAttributes[i]
                current.center = center()
                let chainLink = UIAttachmentBehavior(item: last, attachedToItem: current)
//                let chainLink = UIAttachmentBehavior(item: last, offsetFromCenter: UIOffsetZero, attachedToItem: current, offsetFromCenter: UIOffset(horizontal: 0.5, vertical: 0.5))
                last = current
                animator.addBehavior(chainLink)
                attachments.append(chainLink)
            }
        case .Changed:
            let translation = recognizer.translationInView(collectionView!)
            let attachment = attachments[0]
            let translated = CGPointMake(attachment.anchorPoint.x + translation.x, attachment.anchorPoint.y + translation.y)
            attachment.anchorPoint = translated

        case .Ended:
            let topItem = attachments[0].items[0] as UIDynamicItem
            let push = UIPushBehavior(items: [topItem], mode: UIPushBehaviorMode.Instantaneous)
            let v = recognizer.velocityInView(collectionView)
            push.pushDirection = CGVectorMake(v.x/1000, v.y/1000)

            for behavior in attachments {   //  as [UIAttachmentBehavior]
                let item = behavior.items[0] as UIDynamicItem
                let snap = UISnapBehavior(item: item, snapToPoint: center())
                animator.addBehavior(snap)
                animator.removeBehavior(behavior)
            }
            attachments.removeAll()
            animator.addBehavior(push)
            
            collectionView?.removeGestureRecognizer(pan)
        default:
            false
        }
        recognizer.setTranslation(CGPointZero, inView: collectionView)
    }
}
