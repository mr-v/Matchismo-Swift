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

        let vm = CardViewModel(gameStats: GameStats())

        let vc = window!.rootViewController as ViewController
        vc.viewModel = vm

        return true
    }

}

