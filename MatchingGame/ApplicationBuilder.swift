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
        let playingCardVM = GameViewModel(game: game)

        let setCardMatcher = SetCardMatcher(deck: SetCardFullDeckBuilder().build(), matchReward: 16)
        let setGame = MatchingGame(matcher: setCardMatcher, configuration: penaltyPoints, numberOfCardsToMatch: 3)
        let setVM = GameViewModel(game: setGame)

        var viewModelsWithConfigurations = [(GameViewModel, CardViewBuilder)]()
        viewModelsWithConfigurations.append((setVM, SetCardViewBuilder(matcher: setCardMatcher)))
        viewModelsWithConfigurations.append((playingCardVM, PlayingCardViewBuilder(matcher: playingCardMatcher)))
        let gameControllers = controller.viewControllers as [GameViewController]
        for (index, (vm, builder)) in enumerate(viewModelsWithConfigurations) {
            var vc = gameControllers[index]
            vc.viewModel = vm
            vc.collectionDataSource = GameDataSource(viewModel: vm, cardViewBuilder: builder, cellReuseId: "CardCell")
        }
    }
}
