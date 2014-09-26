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
    let defaultCardTitle = "A♣️"

    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.title = defaultCardTitle
        updateFlipsLabel()
    }

    @IBAction func toggleCard(sender: PlayingCardView) {
        sender.toggle()

        viewModel.incrementFlipCount()
        updateFlipsLabel()
    }

    func updateFlipsLabel() {
        flipsLabel.text = viewModel.flipCountText()
    }
}

