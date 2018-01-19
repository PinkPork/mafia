//
//  ListPLayersPresenter.swift
//  MAFIA
//
//  Created by Hugo Bernal on Dec/29/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol ListPlayersView: class, BaseView {
    func setListPlayers(listPlayers: [PlayersList])
    func addNewList(listPlayer: PlayersList)
    func deleteList(listPlayer: PlayersList, indexPath: IndexPath)
}

class ListPlayersPresenter {
    unowned var view: ListPlayersView
    private let playersListService: PlayersListService
    
    init(view: ListPlayersView, playerListService: PlayersListService = PlayersListService()) {
        self.view = view
        self.playersListService = playerListService
    }
    
    func createList(withName name: String, errorCompletion: (() -> Void)? = nil) {
        playersListService.createPlayersListWith(name: name) { [weak self] (listPlayer) in
            if let listPlayer = listPlayer {
                self?.view.addNewList(listPlayer: listPlayer)
            } else {
                self?.view.showAlert(withTitle: "LIST_ALREADY_ADDED_TITLE".localized(), message: String.localizedStringWithFormat("LIST_ALREADY_ADDED_MESSAGE".localized(), name), preferredStyle: .actionSheet, completionFirstAction: errorCompletion)
            }
        }
    }
    
    func deleteList(playersList: PlayersList, indexPath: IndexPath) {
        playersListService.deleteList(list: playersList) { [weak self] (success) in
             if success {
                self?.view.deleteList(listPlayer: playersList, indexPath: indexPath)
            }
        }
    }
    
    func showListPlayers() {        
        playersListService.getLists { [weak self] (listPlayers) in
            if let list = listPlayers {
                self?.view.setListPlayers(listPlayers: list)
            }
        }
    }
    
    func selectList(list: PlayersList) {
        GameManager.currentGame.setSelectedList(listPlayers: list)
    }
}
