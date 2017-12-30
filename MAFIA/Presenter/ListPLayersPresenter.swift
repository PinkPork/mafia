//
//  ListPLayersPresenter.swift
//  MAFIA
//
//  Created by Hugo Bernal on Dec/29/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol ListPlayersView: class {
    func setListPlayers(listPlayers: [PlayersListMO])
    
}

class ListPlayersPresenter {
    unowned var view: ListPlayersView
    private let playerListService: PlayersListService
    
    init(view: ListPlayersView, playerListService: PlayersListService) {
        self.view = view
        self.playerListService = playerListService
    }
    
    func showListPlayers() {
        playerListService.getPlayers { (listPlayers) in
            if let list = listPlayers {
                self.view.setListPlayers(listPlayers: list)
            }
        }
    }
}
