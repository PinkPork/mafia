//
//  ArrayExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/12/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation


extension Array {
    
    /// Converts an array to a NSSEt
    /// - returns: `NSSet` from self `Array`
    
    func toNSSet() -> NSSet {
        return NSSet(array: self)
    }
}
