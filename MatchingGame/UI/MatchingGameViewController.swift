//
//  MatchingGameViewController.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class MatchingGameViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    var collectionDataSource: CardMatchingGameDataSource!
    var collectionDelegate: CardMatchingGameDelegate!
    var viewModel:GameViewModel!
    var cellReuseId:String = "CardCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionDataSource = CardMatchingGameDataSource(viewModel: viewModel, cellReuseId: cellReuseId)
        collectionDelegate = CardMatchingGameDelegate(cardTappedClosure: didPickCard)

        cardCollectionView.allowsMultipleSelection = true
        cardCollectionView.backgroundColor = UIColor.clearColor()
        cardCollectionView.dataSource = collectionDataSource
        cardCollectionView.delegate = collectionDelegate

        cardCollectionView.collectionViewLayout = FitToBoundsFlowLayout()

        updateLabels()
    }

    func didPickCard(number: Int) {
        viewModel.chooseCardWithNumber(number)
        collectionDataSource.updateVisibleCells(cardCollectionView)

        // cards may have beeen flipped back by the game - need to notify collection view about it
        for number in viewModel.currentlyAvailableCardsNumbers() {
            let indexPath = NSIndexPath(forRow: number, inSection: 0)
            cardCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
        }

        updateLabels()
    }

    @IBAction func redeal(sender: UIButton) {
        viewModel.redeal()

        updateLabels()
        cardCollectionView.reloadData()
    }

    func updateLabels() {
        scoreLabel.text = viewModel.scoreText
    }
}

