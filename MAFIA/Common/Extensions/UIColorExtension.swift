//
//  UIColorExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 4/2/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex value: Int, alpha: CGFloat = 1.0) {
        let r = (value >> 16) & 0xFF
        let g = (value >> 8) & 0xFF
        let b = value & 0xFF

        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: alpha
        )
    }
}
