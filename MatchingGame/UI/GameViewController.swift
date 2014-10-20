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
    let recognizerToAdd: UIGestureRecognizer
    let recognizerToRemove: UIGestureRecognizer
}

class GameViewController: UIViewController {


    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
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

        pinch = UIPinchGestureRecognizer(target: self, action: "fold")
        tap = UITapGestureRecognizer(target: self, action: "unfold")
    
        gridLayoutOptions = LayoutSwitchOptions(layout: gridLayout, cellsSelectable: true, animated: true, recognizerToAdd: pinch, recognizerToRemove: tap)
        stackLayoutOptions = LayoutSwitchOptions(layout: stackLayout, cellsSelectable: false, animated: false, recognizerToAdd: tap, recognizerToRemove: pinch)

        updateScoreLabel()
        unfold()
    }

    @IBAction func redeal(sender: UIButton) {
        viewModel.redeal()
        
        updateScoreLabel()
    
        cardCollectionView.performBatchUpdates({
            let sectionsRange = NSRange(0..<self.cardCollectionView.numberOfSections())
            self.cardCollectionView.reloadSections(NSIndexSet(indexesInRange: sectionsRange))}, completion: nil)
    }

    func unfold() {
        switchLayout(layoutOptions: gridLayoutOptions)
    }

    func fold() {
        switchLayout(layoutOptions: stackLayoutOptions)
    }
 
    private func switchLayout(layoutOptions options: LayoutSwitchOptions) {
        collectionDelegate.selectable = options.cellsSelectable
        cardCollectionView.removeGestureRecognizer(options.recognizerToRemove)
        cardCollectionView.addGestureRecognizer(options.recognizerToAdd)
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

