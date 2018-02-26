//
//  Utils.swift
//  Algorithms
//
//  Created by Santiago Carmona gonzalez on 12/9/17.
//  Copyright © 2017 santicarmo31. All rights reserved.
//

import UIKit
import CoreData

struct Utils {
    
    // MARK: - User Interface
    
    struct UI {
        /// Default navigation bar height value = **44.0**
        static let defaultNavigationBarHeight: CGFloat = 44.0
        
        /// Returns main UIScreen height
        static var screenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
        
        /// Returns main UIScreen width
        static var screenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }
        
        /// Returns main UIScreen bounds
        static var screenBounds: CGRect {
            return UIScreen.main.bounds
        }
        
        /// Returns navigationBarHeight which by default is **44.0** plus the status bar frame height
        static var navigationBarheight: CGFloat {
            return UIApplication.shared.statusBarFrame.size.height + defaultNavigationBarHeight
        }
    }
    
    // MARK: - Colors of the App
    
    /// For more information, see [Mafia palette colors](http://paletton.com/#uid=13K0u0kglbk2lVJ3FigJ49yWU08)
    struct Palette {
        struct Basic {
            static let blue: UIColor = UIColor(red:0.13, green:0.16, blue:0.24, alpha:1.0)
            static let darkBlue: UIColor = UIColor(red:0.01, green:0.07, blue:0.20, alpha:1.0)
            static let white: UIColor = UIColor(red:0.89, green:0.91, blue:0.95, alpha:1.0)
            static let black: UIColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
            static let gray: UIColor = UIColor(red:0.32, green:0.38, blue:0.42, alpha:1.0)
            static let red: UIColor = UIColor(red: 0.56, green: 0.13, blue: 0.13, alpha: 1.0)
        }
    }        
    
}
