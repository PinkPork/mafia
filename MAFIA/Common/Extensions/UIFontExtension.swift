//
//  UIFontExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 4/3/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func get(withType type: Utils.Font, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
