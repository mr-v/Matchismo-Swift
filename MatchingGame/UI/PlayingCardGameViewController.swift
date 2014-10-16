//
//  PlayingCardGameViewController.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 16/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PlayingCardGameViewController: GameViewController {

    override func updateMatchedCards(matched: [NSIndexPath]) {
        collectionDataSource.matchVisibleCellsAtIndexPaths(cardCollectionView, indexPaths: matched)
    }
}
