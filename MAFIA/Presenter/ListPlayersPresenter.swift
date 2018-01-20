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
    func deleteList(listPlayer: PlayersListMO, indexPath: IndexPath)
}

class ListPlayersPresenter {
    unowned var view: ListPlayersView
    private let playersListService: PlayersListService
    
    init(view: ListPlayersView, playerListService: PlayersListService = PlayersListService()) {
        self.view = view
        self.playersListService = playerListService
    }
    
    func createList(withName name: String) {
        playersListService.createPlayersListWith(name: name) { [weak self] (listPlayer) in
            if let listPlayer = listPlayer {
                self?.view.addNewList(listPlayer: listPlayer)
            }
        }
    }
    
    func deleteList(playersList: PlayersListMO, indexPath: IndexPath) {
        playersListService.deleteList(list: playersList) { [weak self] (success) in
             if success {
                self?.view.deleteList(listPlayer: playersList, indexPath: indexPath)
            }
        }
    }
    
    func showListPlayers() {
        playersListService.getPlayers { [weak self] (listPlayers) in
            if let list = listPlayers {
                self?.view.setListPlayers(listPlayers: list)
            }
        }
    }
    
    func selectList(list: PlayersListMO) {
        GameManager.currentGame.setSelectedList(listPlayers: list)
    }
}
