//
//  PlayerPresenter.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/18/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

protocol PlayerView: class {
    func setPlayers(players: [PlayerMO])
    func addNewPlayer(player: PlayerMO)
}

class PlayerPresenter {
    
    unowned let view: PlayerView
    fileprivate let playerService: PlayerService
    
    init(view: PlayerView, playerService: PlayerService) {
        self.view = view
        self.playerService = playerService
    }
    
    func savePlayer(name: String) {
        self.playerService.savePlayer(name: name) {[weak self] (player) in
            if let player = player {
                self?.view.addNewPlayer(player: player)
            }
        }
    }
    
    func showPlayers() {
        playerService.getPlayers { [weak self] (players) in
            if let players = players {
                self?.view.setPlayers(players: PlayerMO.assignRandomRole(to: players))
            }
        }
    }        
}
