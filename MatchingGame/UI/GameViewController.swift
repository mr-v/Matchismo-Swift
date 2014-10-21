//
//  GameViewController.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

private struct LayoutSwitchOptions {
    let layout: UICollectionViewLayout
    let cellsSelectable: Bool
    let animated: Bool
}

class GameViewController: UIViewController {


    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var redealButton: UIButton!
    @IBOutlet weak var requestMoreCardsButton: UIButton?

    var collectionDataSource: GameDataSource!
    var viewModel:GameViewModel!
    private let gridLayout = FitToBoundsFlowLayout()
    private let stackLayout = StackLayout()
    private var collectionDelegate: GameCollectionDelegate!
    private var pinch: UIPinchGestureRecognizer!
    private var tap: UITapGestureRecognizer!
    private var gridLayoutOptions: LayoutSwitchOptions!
    private var stackLayoutOptions: LayoutSwitchOptions!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionDelegate = GameCollectionDelegate(cardTappedClosure: didPickCard)
    
        cardCollectionView.allowsMultipleSelection = true
        cardCollectionView.backgroundColor = UIColor.clearColor()
        cardCollectionView.dataSource = collectionDataSource
        cardCollectionView.delegate = collectionDelegate

        pinch = UIPinchGestureRecognizer(target: self, action: "switchLayout:")
        tap = UITapGestureRecognizer(target: self, action: "unfold")
    
        gridLayoutOptions = LayoutSwitchOptions(layout: gridLayout, cellsSelectable: true, animated: true)
        stackLayoutOptions = LayoutSwitchOptions(layout: stackLayout, cellsSelectable: false, animated: false)

        updateScoreLabel()
        unfold()
        cardCollectionView.addGestureRecognizer(pinch)
    }

    @IBAction func redeal(sender: UIButton) {
        viewModel.redeal()
        
        updateScoreLabel()
    
        unfold()
        cardCollectionView.performBatchUpdates({
            let sectionsRange = NSRange(0..<self.cardCollectionView.numberOfSections())
            self.cardCollectionView.reloadSections(NSIndexSet(indexesInRange: sectionsRange))}, completion: nil)
    }

    func switchLayout(recognizer: UIPinchGestureRecognizer) {
        let pinchIn = recognizer.scale < 1
        pinchIn ? fold() : unfold()
    }

    func unfold() {
        switchLayout(layoutOptions: gridLayoutOptions)
        cardCollectionView.removeGestureRecognizer(tap)
    }

    func fold() {
        switchLayout(layoutOptions: stackLayoutOptions)
        cardCollectionView.addGestureRecognizer(tap)
    }

    private func switchLayout(layoutOptions options: LayoutSwitchOptions) {
        collectionDelegate.selectable = options.cellsSelectable
        let buttons = [requestMoreCardsButton, redealButton]
        for b in buttons {
            let enabled = options.cellsSelectable
            b?.enabled = enabled
            b?.alpha = enabled ? 1 : 0.5
        }
        if options.animated {
            cardCollectionView.setCollectionViewLayout(options.layout, animated: options.animated)
        } else {
            cardCollectionView.collectionViewLayout = options.layout
        }
    }

    private func didPickCard(number: Int) {
        let results = viewModel.chooseCardWithNumber(number)
        updateUnchosenCards(results.unchosen)
        updateMatchedCards(results.matched)

        updateScoreLabel()
    }

    private func updateUnchosenCards(indexPaths: [NSIndexPath]) {
        // cards may have beeen flipped back by the game - need to notify collection view about it
        collectionDataSource.deselectVisibleCellsAtIndexPaths(cardCollectionView, indexPaths: indexPaths)
        for i in indexPaths {
            cardCollectionView.deselectItemAtIndexPath(i, animated: false)
        }
    }

    func updateMatchedCards(matched: [NSIndexPath]) {
        fatalError("implement \(__FUNCTION__) method in a subclass")
    }

    private func updateScoreLabel() {
        scoreLabel.text = viewModel.scoreText
    }
}

