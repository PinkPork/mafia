//
//  ListPLayersPresenter.swift
//  MAFIA
//
//  Created by Hugo Bernal on Dec/29/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol ListBrowserView: AnyObject, BaseView {
    func setListPlayers(listPlayers: [PlayerList])
    func addNewList(listPlayer: PlayerList)
    func deleteList(listPlayer: PlayerList, indexPath: IndexPath)
}

class ListBrowserPresenter {
    unowned var view: ListBrowserView
    private let playersListService: ListService
    
    init(view: ListBrowserView, playerListService: ListService = ListService()) {
        self.view = view
        self.playersListService = playerListService
    }
    
    func createList(withName name: String, errorCompletion: (() -> Void)? = nil) {
        playersListService.createListWith(name: name) { [weak self] (listPlayer) in
            if let listPlayer = listPlayer {
                self?.view.addNewList(listPlayer: listPlayer)
            } else {
                self?.view.showAlert(withTitle: "LIST_ALREADY_ADDED_TITLE".localized(), message: String.localizedStringWithFormat("LIST_ALREADY_ADDED_MESSAGE".localized(), name), preferredStyle: .actionSheet, completionFirstAction: errorCompletion)
            }
        }
    }
    
    func deleteList(playersList: PlayerList, indexPath: IndexPath) {
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
    
    func selectList(list: PlayerList) {
        GameManager.currentGame.setSelectedList(listPlayers: list)
    }
}
