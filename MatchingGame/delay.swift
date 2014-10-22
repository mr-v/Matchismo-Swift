//
//  delay.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 20/10/14.
//

import Foundation

// http://stackoverflow.com/a/24318861

func delay(delayInSeconds :Double, closure :()->()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds  * Double(NSEC_PER_SEC))),
        dispatch_get_main_queue(), closure)
}
