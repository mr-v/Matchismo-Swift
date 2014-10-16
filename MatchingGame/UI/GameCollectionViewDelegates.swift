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

class CardMatchingGameDataSource: NSObject, UICollectionViewDataSource {
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

    func updateVisibleCells(collectionView: UICollectionView) {
        for i in collectionView.indexPathsForVisibleItems() {
            let path = i as NSIndexPath
            configureCell(collectionView.cellForItemAtIndexPath(path) as CardViewCell, number: path.row)
        }
    }

    func configureCell(cell: CardViewCell, number: Int) {
        cell.cardView = cardViewBuilder.viewForCardWithNumber(number)
        cell.enabled = !viewModel.isCardMatched(number)
        cell.selected = viewModel.isCardChosen(number)
    }
}

class CardMatchingGameDelegate: NSObject, UICollectionViewDelegateFlowLayout {
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