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
    func addNewList(listPlayer: PlayersListMO)
}

class ListPlayersPresenter {
    unowned var view: ListPlayersView
    private let playerListService: PlayersListService
    
    init(view: ListPlayersView, playerListService: PlayersListService) {
        self.view = view
        self.playerListService = playerListService
    }
    
    func createList(withName name: String) {
        playerListService.createPlayersListWith(name: name) { [weak self] (listPlayer) in
            if let listPlayer = listPlayer {
                self?.view.addNewList(listPlayer: listPlayer)
            }
        }
    }
    
    func showListPlayers() {
        playerListService.getPlayers { [weak self] (listPlayers) in
            if let list = listPlayers {
                self?.view.setListPlayers(listPlayers: list)
            }
        }
    }
}
