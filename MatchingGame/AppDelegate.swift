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
        let points = PointsConfiguration(choosePenalty: 1, suitMatchReward: 4, rankMatchReward: 16, mismatchPenalty: 2)
        let game = MatchingGame(configuration: points, numberOfCards: 12)
        let vm = CardViewModel(game: game)

        let vc = window!.rootViewController as ViewController
        vc.viewModel = vm

        return true
    }

}

