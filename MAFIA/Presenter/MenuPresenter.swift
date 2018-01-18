//
//  MenuPresenter.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/27/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

protocol MenuView: class {
    func setMenu(options: [MenuOptions])
}

class MenuPresenter {
    
    unowned let view: MenuView
    
    init(view: MenuView) {
        self.view = view
    }
    
    func displayOptions() {
        self.view.setMenu(options: [.PlayersList])
    }
}
