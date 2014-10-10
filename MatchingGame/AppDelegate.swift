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
        let matchPoints = PenaltyPointConfiguration(choosePenalty: -1, mismatchPenalty: -2)
        let playingCardGamePoints = PlayingCardRewardPointConfiguration(suitReward: 4, rankReward: 16, partialMatchMultiplier: 0.5)
        let deck = PlayingCardFullDeckBuilder().build()
        let playingCardMatcher = PlayingCardMatcher(numberOfCards: 30, rewardConfiguration: playingCardGamePoints, deck: deck)
        let game = MatchingGame(matcher: playingCardMatcher, configuration: matchPoints, numberOfCardsToMatch: 2)
        let vm = GameViewModel(game: game, printer: PlayingCardSymbolPrinter(matcher: playingCardMatcher))
        let nav = window!.rootViewController as UINavigationController
        let vc = nav.topViewController as ViewController
        vc.viewModel = vm

        return true
    }

}

