//
//  SetGameViewController.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 16/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class SetGameViewController: GameViewController {

    @IBOutlet weak var requestMoreCardsView: UIButton!

    override func updateMatchedCards(matched: [NSIndexPath]) {
        cardCollectionView.performBatchUpdates({ self.cardCollectionView.deleteItemsAtIndexPaths(matched) }, completion: nil)
    }

    @IBAction func requestAdditionalCards() {
        let added = viewModel.requestNewCards()
        requestMoreCardsView.enabled = !added.isEmpty
        requestMoreCardsView.alpha = !added.isEmpty ? 1 : 0
        cardCollectionView.performBatchUpdates({ self.cardCollectionView.insertItemsAtIndexPaths(added) }, completion: nil)
    }

    override func redeal(sender: UIButton) {
        super.redeal(sender)
        requestMoreCardsView.enabled = true
        requestMoreCardsView.alpha = 1
    }
}
