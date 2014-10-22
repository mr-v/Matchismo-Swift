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
    func buildAppWithRootViewController(rootController: UITabBarController) {
        let penaltyPoints = PenaltyPointConfiguration(choosePenalty: -1, mismatchPenalty: -2)

        // prepare playing card game related things
        let playingCardRewards = PlayingCardRewardPointConfiguration(suitReward: 4, rankReward: 16, partialMatchMultiplier: 0.5)
        let deck = PlayingCardFullDeckBuilder().build()
        let playingCardMatcher = PlayingCardMatcher(numberOfCards: 25, rewardConfiguration: playingCardRewards, deck: deck)
        let game = MatchingGame(matcher: playingCardMatcher, configuration: penaltyPoints, numberOfCardsToMatch: 2)
        let playingCardVM = GameViewModel(game: game)

        // prepare set game related things
        let setCardMatcher = SetCardMatcher(deck: SetCardFullDeckBuilder().build(), matchReward: 16)
        let setGame = MatchingGame(matcher: setCardMatcher, configuration: penaltyPoints, numberOfCardsToMatch: 3)
        let setVM = GameViewModel(game: setGame)

        var configurations = [(GameViewModel, CardViewBuilder, TabBarImageFromText)]()
        configurations.append((playingCardVM, PlayingCardViewBuilder(matcher: playingCardMatcher), TabBarImageFromText(text: "♡")))
        configurations.append((setVM, SetCardViewBuilder(matcher: setCardMatcher), TabBarImageFromText(text: "◇")))

        let gameControllers = rootController.viewControllers as [GameViewController]
        for (index, (vm, builder, imageFactory)) in enumerate(configurations) {
            var vc = gameControllers[index]
            vc.viewModel = vm
            vc.collectionDataSource = GameDataSource(viewModel: vm, cardViewBuilder: builder, cellReuseId: "CardCell")
            setControllerTabBarImages(vc, imageFactory: imageFactory)
        }
    }

    func setControllerTabBarImages(controller: UIViewController, imageFactory: TabBarImageFromText) {
        controller.tabBarItem.image = imageFactory.defaultImage()
        controller.tabBarItem.selectedImage = imageFactory.selectedImage()
    }
}
