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
        updateLabels()
        updateCardMatchMode()
    }

    func didPickCard(number: Int) {
        matchModeControl.enabled = false

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

        for number in viewModel.matchedCardNumbers {
            let indexPath = NSIndexPath(forRow: number, inSection: 0)
            let cell = cardCollectionView.cellForItemAtIndexPath(indexPath) as CardViewCell
            cell.enabled = false
        }

        updateLabels()
    }

    @IBAction func redeal(sender: UIButton) {
        matchModeControl.enabled = true
        viewModel.redeal()

        updateLabels()
        collectionDataSource.resetAllCells(cardCollectionView)
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
}

