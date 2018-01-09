//
//  NSSetExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/9/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

extension NSSet {
    func toArray<Type>() -> [Type] {
        return Array(self) as! [Type]
    }
}
