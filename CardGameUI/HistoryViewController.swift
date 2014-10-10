//
//  HistoryViewController.swift
//  MatchingGame
//
//  Created by Witold Skibniewski on 10/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    private var text: NSMutableAttributedString!

    override func viewDidLoad() {
        super.viewDidLoad()
        let range = NSRange(location: 0, length: text.length)
        text.addAttribute(NSFontAttributeName, value: UIFont.preferredFontForTextStyle(UIFontTextStyleBody), range: range)
        textView.attributedText = text
    }

    func setHistoryText(history: [NSAttributedString]) {
        text = history.reduce(NSMutableAttributedString(string: "")) {
            acc, action in
            acc.appendAttributedString(action);
            acc.appendAttributedString(NSAttributedString(string: "\n"))
            return acc
        }
    }
}
