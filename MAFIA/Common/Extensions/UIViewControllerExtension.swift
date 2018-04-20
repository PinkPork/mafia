//
//  UIViewControllerExtension.swift
//  MAFIA
//
//  Created by Luis Alejandro Ramirez Suarez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String?, message: String?, preferredStyle: UIAlertControllerStyle = .alert, completionFirstAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okayAction = UIAlertAction(title: "OKAY".localized(), style: .default) { _ in
            completionFirstAction?()
        }
        
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}

extension UIViewController: BaseView {
    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertControllerStyle, completionFirstAction: (() -> Void)?) {
        self.presentAlert(title: title, message: message, preferredStyle: preferredStyle, completionFirstAction: completionFirstAction)
    }
}
