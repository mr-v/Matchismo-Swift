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
    @IBOutlet weak var lastActionLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    var collectionDataSource: PlayingCardMatchingGameDataSource!
    var collectionDelegate: PlayingCardMatchingGameDelegate!
    var viewModel:GameViewModel!


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionDataSource = PlayingCardMatchingGameDataSource(viewModel: viewModel)
        collectionDelegate = PlayingCardMatchingGameDelegate(cardTappedClosure: didPickCard)

        cardCollectionView.allowsMultipleSelection = true
        cardCollectionView.backgroundColor = UIColor.clearColor()
        cardCollectionView.dataSource = collectionDataSource
        cardCollectionView.delegate = collectionDelegate

        var layout = cardCollectionView.collectionViewLayout as UICollectionViewFlowLayout
        uppdateItemSizeForCurrentSizeClass(layout)

        updateLabels()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "ShowHistory":
            prepareForHistorySegue(segue.destinationViewController as HistoryViewController)
        default:
            fatalError("unhandled segue")
        }
    }

    func prepareForHistorySegue(vc: HistoryViewController) {
        vc.setHistoryText(viewModel.actionsHistory)
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
        lastActionLabel.attributedText = viewModel.lastActionText()
    }

    func uppdateItemSizeForCurrentSizeClass(layout: UICollectionViewFlowLayout) {
        let a = UITraitCollection(horizontalSizeClass: .Regular)
        let b = UITraitCollection(verticalSizeClass: .Regular)
        let regularSizeClassTraitCollection = UITraitCollection(traitsFromCollections: [a, b])
        if !traitCollection.containsTraitsInCollection(regularSizeClassTraitCollection) {
            layout.itemSize = CGSize(width: 40, height: 60)
        }
    }
}

