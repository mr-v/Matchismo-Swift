//
//  AppDelegate.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 26/09/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let tabController =  window!.rootViewController as UITabBarController

        let penaltyPoints = PenaltyPointConfiguration(choosePenalty: -1, mismatchPenalty: -2)

        let playingCardRewards = PlayingCardRewardPointConfiguration(suitReward: 4, rankReward: 16, partialMatchMultiplier: 0.5)
        let deck = PlayingCardFullDeckBuilder().build()
        let playingCardMatcher = PlayingCardMatcher(numberOfCards: 30, rewardConfiguration: playingCardRewards, deck: deck)
        let game = MatchingGame(matcher: playingCardMatcher, configuration: penaltyPoints, numberOfCardsToMatch: 2)
        let playingCardVM = GameViewModel(game: game, printer: PlayingCardSymbolPrinter(matcher: playingCardMatcher))

        let setCardMatcher = SetCardMatcher(deck: SetCardFullDeckBuilder().build(), matchReward: 16)
        let setGame = MatchingGame(matcher: setCardMatcher, configuration: penaltyPoints, numberOfCardsToMatch: 3)
        let setVM = GameViewModel(game: setGame, printer: SetCardSymbolPrinter(matcher: setCardMatcher))

        let viewModels = [(playingCardVM, "PlayingCardCell", "Playing Cards"), (setVM, "SetCardCell", "Set")]
        let controllers: [UIViewController] = viewModels.map {
            (vm, reuseId, gameType) in
            let nav = tabController.storyboard!.instantiateViewControllerWithIdentifier("MatchingGame") as UINavigationController
            let vc = nav.topViewController as ViewController
            vc.viewModel = vm
            vc.cellReuseId = reuseId
            vc.title = gameType
            return nav
        }

        tabController.viewControllers = controllers
        return true
    }

}

