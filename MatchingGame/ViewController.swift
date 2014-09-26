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

    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.title = "A♣️"
    }

    @IBAction func toggleCard(sender: PlayingCardView) {
        sender.toggle()
    }

}

