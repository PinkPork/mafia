//
//  NSSetExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/9/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

extension NSSet {
    
    /// Converts the set into an array of the same type
    /// - returns: An Array containing the objects from the set
    func toArray<Type>() -> [Type] {
        return Array(self) as! [Type]
    }
}
