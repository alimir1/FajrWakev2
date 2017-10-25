//
//  NSAttributedString+Helpers.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/25/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

extension NSAttributedString {
    class func bigSmallFormattedString(biggerString: String, smallerString: String, biggerFontSize: CGFloat, smallerFontSize: CGFloat) -> NSAttributedString {
        let combination = NSMutableAttributedString()
        let adjustMins = NSMutableAttributedString(string: biggerString)
        let min = NSMutableAttributedString(string: smallerString)
        adjustMins.addAttribute(.font, value: UIFont.systemFont(ofSize: biggerFontSize), range: NSMakeRange(0, biggerString.count))
        min.addAttribute(.font, value: UIFont.systemFont(ofSize: smallerFontSize), range: NSMakeRange(0, smallerString.count))
        combination.append(adjustMins)
        combination.append(min)
        return combination
    }
}
