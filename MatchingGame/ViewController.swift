//
//  ViewController.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardView: PlayingCardView!
    @IBOutlet weak var flipsLabel: UILabel!

    var viewModel:CardViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.toggle()
        updateScoreLabel()
    }

    @IBAction func toggleCard(sender: PlayingCardView) {
//        viewModel.incrementFlipCount()
//        updateScoreLabel()
//        
//        sender.enabled = !viewModel.isDeckEmpty
//        if cardView.faceDirection == CardFace.Down {
//            cardView.title = viewModel.currentCardTitle
//        }
//        sender.toggle()
    }

    func updateScoreLabel() {
        flipsLabel.text = viewModel.scoreText
    }


}

