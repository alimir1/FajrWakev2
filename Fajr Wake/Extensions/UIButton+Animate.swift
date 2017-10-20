//
//  UIButton+Animate.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/20/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

extension UIButton {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
}
