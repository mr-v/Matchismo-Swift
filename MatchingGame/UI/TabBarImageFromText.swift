//
//  TabBarImageFromText.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 21/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class TabBarImageFromText {
    private let size = CGSize(width: 76, height: 76)
    private let defaultAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(20)]
    private let selectedAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(19), NSStrokeWidthAttributeName: -10]
    private var text: String

    init(text: String) {
        self.text = text
    }

    func defaultImage() -> UIImage {
        return imageFromText(NSAttributedString(string: text, attributes: defaultAttributes))
    }

    func selectedImage() -> UIImage {
        return imageFromText(NSAttributedString(string: text, attributes: selectedAttributes))
    }

    private func imageFromText(text: NSAttributedString) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)  // UIGraphicsBeginImageContext - pixelated on retina screens
        let context = UIGraphicsGetCurrentContext()
        let bounds = CGRect(origin: CGPointZero, size: size)
        // use default attributes to keep alignment for outlined text
        let textSize = NSAttributedString(string: self.text, attributes: defaultAttributes).size()
        let center = CGPoint(x: bounds.midX - round(textSize.width/2), y: bounds.midY - round(textSize.height/2))
        text.drawAtPoint(center)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
