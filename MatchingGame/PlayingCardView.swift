//
//  PlayingCardView.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

 enum CardFace {
    case Up
    case Down

    func cardFaceImageName() -> String {
        switch self {
        case .Up:
            return "card_front"
        case .Down:
            return "card_back"
        }
    }
}

class PlayingCardView : UIButton {

    var title: String? {
        didSet {
            setLabelsTitle(title!)
        }
    }
    private var faceDirection: CardFace = .Up

    func toggle() {
        switch faceDirection {
        case .Up:
            faceDirection = .Down
            setLabelsTitle("")
        case .Down:
            faceDirection = .Up
            setLabelsTitle(title!)  // should be ? for safety, but compiler would not allow it despite the message about missing '?'
        }

        setBackgroundImage(UIImage(named: faceDirection.cardFaceImageName()), forState: .Normal)
    }

    private func setLabelsTitle(title: String) {
        setTitle(title, forState: .Normal)
    }


}