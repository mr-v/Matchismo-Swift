//
//  ApplicationBuilder.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 15/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

// builds application's object graph

class ApplicationBuilder {
    func buildAppWithRootViewController(controller: UITabBarController) {
        let penaltyPoints = PenaltyPointConfiguration(choosePenalty: -1, mismatchPenalty: -2)

        let playingCardRewards = PlayingCardRewardPointConfiguration(suitReward: 4, rankReward: 16, partialMatchMultiplier: 0.5)
        let deck = PlayingCardFullDeckBuilder().build()
        let playingCardMatcher = PlayingCardMatcher(numberOfCards: 25, rewardConfiguration: playingCardRewards, deck: deck)
        let game = MatchingGame(matcher: playingCardMatcher, configuration: penaltyPoints, numberOfCardsToMatch: 2)
        let playingCardVM = GameViewModel(game: game, cardViewBuilder: PlayingCardViewBuilder(matcher: playingCardMatcher))

        let setCardMatcher = SetCardMatcher(deck: SetCardFullDeckBuilder().build(), matchReward: 16)
        let setGame = MatchingGame(matcher: setCardMatcher, configuration: penaltyPoints, numberOfCardsToMatch: 3)
        let setVM = GameViewModel(game: setGame, cardViewBuilder: SetCardViewBuilder(matcher: setCardMatcher))

        let viewModelsWithConfigurations = [(playingCardVM, "Playing Cards"), (setVM, "Set")]
        let mainStoryboard = controller.storyboard!
        let controllers: [UIViewController] = viewModelsWithConfigurations.map {
            (vm, gameType) in
            let identifier = "MatchingGameViewController"
            let vc = mainStoryboard.instantiateViewControllerWithIdentifier(identifier) as MatchingGameViewController
            vc.viewModel = vm
            vc.title = gameType
            return vc
        }
        controller.viewControllers = controllers
    }
}