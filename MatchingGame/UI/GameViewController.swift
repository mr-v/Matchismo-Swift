//
//  GameViewController.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    var collectionDataSource: GameDataSource!
    var collectionDelegate: GameCollectionDelegate!
    var viewModel:GameViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionDelegate = GameCollectionDelegate(cardTappedClosure: didPickCard)
        cardCollectionView.allowsMultipleSelection = true
        cardCollectionView.backgroundColor = UIColor.clearColor()
        cardCollectionView.dataSource = collectionDataSource
        cardCollectionView.delegate = collectionDelegate
        cardCollectionView.collectionViewLayout = FitToBoundsFlowLayout()

        updateScoreLabel()
    }

    func didPickCard(number: Int) {
        let results = viewModel.chooseCardWithNumber(number)
        updateUnchosenCards(results.unchosen)
        updateMatchedCards(results.matched)

        updateScoreLabel()
    }

    func updateUnchosenCards(indexPaths: [NSIndexPath]) {
        collectionDataSource.deselectVisibleCellsAtIndexPaths(cardCollectionView, indexPaths: indexPaths)
        // cards may have beeen flipped back by the game - need to notify collection view about it
        for i in indexPaths {
            cardCollectionView.deselectItemAtIndexPath(i, animated: false)
        }
    }

    func updateMatchedCards(matched: [NSIndexPath]) {
        fatalError("implement \(__FUNCTION__) method in a subclass")
    }

    @IBAction func redeal(sender: UIButton) {
        viewModel.redeal()

        updateScoreLabel()
        cardCollectionView.reloadData()
    }

    func updateScoreLabel() {
        scoreLabel.text = viewModel.scoreText
    }
}

