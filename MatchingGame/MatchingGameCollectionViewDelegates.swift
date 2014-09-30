//
//  MatchingGameCollectionViewDelegates.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 29/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

// delegates to ViewModel, beacause adding this to ViewModel would create UIKit depencency
/*
    unit test ideas - test number of sections

*/

class MatchingGameDataSource: NSObject, UICollectionViewDataSource {
    let cellReuseId = "CardCell"
    private let viewModel: CardViewModel

    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCards
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseId, forIndexPath: indexPath) as CardViewCell
        cell.title.text = viewModel.textForCardWithNumber(indexPath.row)
        return cell
    }

}

class MatchingGameDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    let cardTappedClosure: (cardNumber: Int) -> ()

    init(cardTappedClosure: (Int) -> ()) {
        self.cardTappedClosure = cardTappedClosure
        super.init()
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // pick a card!
        cardTappedClosure(cardNumber: indexPath.row)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        cardTappedClosure(cardNumber: indexPath.row)
    }
}