//
//  MatchingGameCollectionViewDelegates.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 29/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

protocol CardViewBuilder {
    func viewForCardWithNumber(number: Int) -> CardView
}

class GameDataSource: NSObject, UICollectionViewDataSource {
    let cellReuseId: String

    private let viewModel: GameViewModel
    private let cardViewBuilder: CardViewBuilder

    init(viewModel: GameViewModel, cardViewBuilder:CardViewBuilder, cellReuseId: String) {
        self.viewModel = viewModel
        self.cellReuseId = cellReuseId
        self.cardViewBuilder = cardViewBuilder
        super.init()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCards
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseId, forIndexPath: indexPath) as CardViewCell
        configureCell(cell, number: indexPath.row)
        return cell
    }

    func deselectVisibleCellsAtIndexPaths(collectionView: UICollectionView, indexPaths: [NSIndexPath]) {
        for i in indexPaths {
            if let cell = collectionView.cellForItemAtIndexPath(i) as CardViewCell? {
                cell.selected = false
            }
        }
    }

    func matchVisibleCellsAtIndexPaths(collectionView: UICollectionView, indexPaths: [NSIndexPath]) {
        for i in indexPaths {
            if let cell = collectionView.cellForItemAtIndexPath(i) as CardViewCell? {
                cell.enabled = false
            }
        }
    }

    func configureCell(cell: CardViewCell, number: Int) {
        cell.cardView = cardViewBuilder.viewForCardWithNumber(number)
    }
}

class GameCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    let cardTappedClosure: (cardNumber: Int) -> ()

    init(cardTappedClosure: (Int) -> ()) {
        self.cardTappedClosure = cardTappedClosure
        super.init()
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // pick a card
        cardTappedClosure(cardNumber: indexPath.row)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        cardTappedClosure(cardNumber: indexPath.row)
    }
}