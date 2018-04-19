//
//  UIViewExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 4/2/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

extension UIView {
    /**
     * Adds a gradient from top to bottom with the given colors
     * - parameter colors: The colors used in the gradient
     */
    func addGradient(colors: CGColor...) {
        addGradient(colors)
    }

    /**
     * Adds a gradient from top to bottom with the given colors
     *
     * **Default** colors are:
     *
     *     [Utils.Palette.Basic.red.cgColor, Utils.Palette.Basic.black.cgColor]
     * - parameter colors: The colors used in the gradient
     */
    func addGradient(_ colors: [CGColor]? = [Utils.Palette.Basic.red.cgColor, Utils.Palette.Basic.black.cgColor]) {
        self.layoutIfNeeded()
        let gradient = CAGradientLayer()
        gradient.colors = colors
        self.layer.masksToBounds = true
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
