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
    @IBOutlet weak var matchModeControl: UISegmentedControl!
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

        var layout = cardCollectionView.collectionViewLayout as UICollectionViewFlowLayout
        uppdateItemSizeForCurrentSizeClass(layout)

        updateLabels()
        updateCardMatchMode()
    }

    @IBOutlet weak var helperView: UIView!
    func didPickCard(number: Int) {
        matchModeControl.enabled = false

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
        matchModeControl.enabled = true
        viewModel.redeal()

        updateLabels()
        cardCollectionView.reloadData()
    }

    @IBAction func changeCardMode(sender: AnyObject) {
        updateCardMatchMode()
    }

    func updateCardMatchMode() {
        switch matchModeControl.selectedSegmentIndex {
        case 0:
            viewModel.changeModeWithNumberOfCardsToMatch(2)
        case 1:
            viewModel.changeModeWithNumberOfCardsToMatch(3)
        default:
            fatalError("unexpected matching mode")
        }
    }

    func updateLabels() {
        scoreLabel.text = viewModel.scoreText
        lastActionLabel.text = viewModel.lastActionText()
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

