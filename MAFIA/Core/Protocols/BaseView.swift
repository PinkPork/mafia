//
//  BaseView.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol BaseView {
    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertControllerStyle, completionFirstAction: (() -> Void)?)
}
