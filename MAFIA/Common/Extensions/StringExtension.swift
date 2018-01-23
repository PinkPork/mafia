//
//  StringExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 12/20/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

extension String {
    
    var utf8Data: Data? {
        return data(using: .utf8)
    }
    
    /**
     Get the localized string with empty comment, first will search the key in Default.strings file and
     if the key is not found, it will search in Localized.string file.
     
     - returns: A localized string, if not found returns an empty string
     */
    func localized() -> String {
        return localized(withComment: "")
    }
    
    /**
     Get the localized string, first will search the key in Default.strings file and
     if the key is not found, it will search in Localized.string file.
     
     - parameter withComment: comment
     - returns: A localized string, if not found returns an empty string
     */
    func localized(withComment: String) -> String {
        var localized = Bundle.main.localizedString(forKey: self, value: withComment, table: "Default")
        if localized == self {
            localized = Bundle.main.localizedString(forKey: self, value: withComment, table: nil)
            if localized == self {
                return self
            }
        }
        return localized
    }
    
    func capitalizeFirst() -> String {
        let offset = 1
        if self.count >= offset {
            let firstIndex = self.index(startIndex, offsetBy: 1)
            return self[..<firstIndex].capitalized + self[firstIndex...].lowercased()
        } else {
            return ""
        }
    }
}
