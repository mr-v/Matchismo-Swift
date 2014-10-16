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
        let inTests = NSClassFromString("XCTest") != nil
        if inTests {
            return true
        }

        // storyboard initialized via code - otherwise it did launch during unit tests and threw errors
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabController = storyboard.instantiateInitialViewController() as UITabBarController
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = tabController
        ApplicationBuilder().buildAppWithRootViewController(tabController)

        window!.makeKeyAndVisible()
        return true
    }
    
}

