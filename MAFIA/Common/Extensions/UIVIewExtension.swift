//
//  UIVIewExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/27/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit


extension UIView {
    func rotate(degrees: Double = 1.0, duration: CFTimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * degrees)
        rotateAnimation.duration = duration
        
        if let delegate = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
