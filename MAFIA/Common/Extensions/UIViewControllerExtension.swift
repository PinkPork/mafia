//
//  UIViewControllerExtension.swift
//  MAFIA
//
//  Created by Luis Alejandro Ramirez Suarez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentActionSheet(title: String?, message: String?) {
        let alertActionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okayAction = UIAlertAction(title: "OKAY".localized(), style: .default, handler: nil)
        
        alertActionSheet.addAction(okayAction)
        
        self.present(alertActionSheet, animated: true, completion: nil)
    }
}
