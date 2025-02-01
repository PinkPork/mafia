import SwiftUI

enum Icon: String {
    // SF Symbols
    case dotScope = "dot.scope"
    case king = "king" // "crown.fill"
    case doctor = "doctor" // "cross.case.fill"
    case sheriff = "sheriff" // "star.fill"
    case none = "xmark"
    case refresh = "arrow.clockwise"
    case plus = "person.badge.plus"
    case plusList = "text.badge.plus"
    case list = "list.bullet"

    case mob = "wanted"
    case villager = "villager"
}

extension Image {
    init(icon: Icon) {
        if let image = UIImage(systemName: icon.rawValue) {
            self.init(systemName: icon.rawValue)
        } else if let image = UIImage(named: icon.rawValue) {
            self.init(icon.rawValue)
        } else {
            fatalError("Couldn't find image named: \(icon.rawValue)")
        }        
    }
}
