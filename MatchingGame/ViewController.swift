//
//  ViewController.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    var collectionDataSource: MatchingGameDataSource!
    var collectionDelegate: MatchingGameDelegate!
    var viewModel:CardViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionDataSource = MatchingGameDataSource(viewModel: viewModel)
        collectionDelegate = MatchingGameDelegate(cardTappedClosure: didPickCard)

        cardCollectionView.allowsMultipleSelection = true
        cardCollectionView.backgroundColor = UIColor.clearColor()
        cardCollectionView.dataSource = collectionDataSource
        cardCollectionView.delegate = collectionDelegate
        updateScoreLabel()
    }

    func didPickCard(number: Int) {
        viewModel.chooseCardWithNumber(number)
        for number in viewModel.currentlyAvailableCardsNumbers() {
            let indexPath = NSIndexPath(forRow: number, inSection: 0)
            let cell = cardCollectionView.cellForItemAtIndexPath(indexPath) as CardViewCell
            if cell.selected {
                cell.selected = false
                cardCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
                println("\(cell)")
            }
        }

        updateScoreLabel()
    }

    func updateScoreLabel() {
        scoreLabel.text = viewModel.scoreText
    }
}

