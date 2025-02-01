//
//  DetailListPlayersPresenter.swift
//  MAFIA
//
//  Created by Luis Ramirez on 1/7/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

protocol ListView: AnyObject, BaseView {
    func addNewPlayer(player: Player)
    func deletePlayer(player: Player, indexPath: IndexPath)
}

class ListPresenter {
    unowned var view: ListView
    private let detailListPlayersService: DetailListPlayersService
    
    init(view: ListView, detailListPlayersService: DetailListPlayersService = DetailListPlayersService()) {
        self.view = view
        self.detailListPlayersService = detailListPlayersService
    }
    
    func addPlayer(withName name: String, toList list: PlayerList, errorCompletion: (() -> Void)? = nil) {
        
        guard list.players.filter({ $0.name == name }).count == 0 else {
            self.view.showAlert(withTitle: "PLAYER_ALREADY_ADDED_TITLE".localized(),
                                message: "PLAYER_ALREADY_ADDED_MESSAGE".localized(),
                                preferredStyle: .actionSheet,
                                completionFirstAction: errorCompletion)
            return
        }
        
        detailListPlayersService.add(toList: list, playerWithName: name) { [weak self] (player) in
            if let player = player {
                self?.view.addNewPlayer(player: player)                
            }
        }
    }
    
    func deletePlayer(player: Player, list: PlayerList, indexPath: IndexPath) {
        detailListPlayersService.remove(player, fromList: list) { [weak self] (success) in
            if success {
                self?.view.deletePlayer(player: player, indexPath: indexPath)
            }
        }
    }
    
}
