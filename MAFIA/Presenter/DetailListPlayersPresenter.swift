//
//  DetailListPlayersPresenter.swift
//  MAFIA
//
//  Created by Luis Ramirez on 1/7/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

protocol DetailListPlayersView: class {
    func addNewPlayers(players: [PlayerMO])
    func deletePlayer(player: PlayerMO, indexPath: IndexPath)
}

class DetailListPlayersPresenter {
    unowned var view: DetailListPlayersView
    private let detailListPlayersService: DetailListPlayersService
    
    init(view: DetailListPlayersView, detailListPlayersService: DetailListPlayersService = DetailListPlayersService()) {
        self.view = view
        self.detailListPlayersService = detailListPlayersService
    }
    
    func addPlayer(withName name: String, list: PlayersListMO) {
        detailListPlayersService.add(toList: list, playersWithName: [name]) { [weak self] (players) in
            if let players = players {
                self?.view.addNewPlayers(players: players)
            }
        }
    }
    
    func deletePlayer(player: PlayerMO, list: PlayersListMO, indexPath: IndexPath) {
        detailListPlayersService.remove(player, fromList: list) { [weak self] (success) in
            if success {
                self?.view.deletePlayer(player: player, indexPath: indexPath)
            }
        }
    }

}
