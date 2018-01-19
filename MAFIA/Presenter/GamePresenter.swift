//
//  GamePresenter.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/18/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

protocol GameView: class {
    func setPlayers(players: [PlayerMO])
    func addNewPlayer(player: PlayerMO)
    func deletePlayer(player: PlayerMO, indexPath: IndexPath)
    func updateGameUI()
    func endGame(winner: Role)
    func restartGame()
}

class GamePresenter {
    
    private unowned let view: GameView
    fileprivate let playerService: PlayerService
    
    var aliveCiviliansPlayerText: String {
        return "\("CIVILIANS_TITLE".localized()) \n \(GameManager.currentGame.aliveCivilians)"
    }
    
    var aliveMafiaPlayerText: String {
        return "\("MAFIA_TITLE".localized()) \n \(GameManager.currentGame.aliveMafia)"
    }
    
    var selectedListName: String? {
        return GameManager.currentGame.listName
    }
    
    init(view: GameView, playerService: PlayerService = PlayerService()) {
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
        if let players = GameManager.currentGame.playersPlaying {
            view.setPlayers(players: refreshRoles(players: players))
            view.updateGameUI()
        }
    }
    
    func refreshRoles(players: [PlayerMO]) -> [PlayerMO] {
        if players.count >= GameRules.minimumPlayers {
            return PlayerMO.assignRandomRole(to: players)
        }
        return players
    }
    
    func deletePlayer(player: PlayerMO, indexPath: IndexPath) {
        playerService.deletePlayer(player: player) { [weak self] (success) in
            if success {
                self?.view.deletePlayer(player: player, indexPath: indexPath)
            }
        }
    }
    
    func kill(player: PlayerMO) {
        GameManager.currentGame.kill(player)
        view.updateGameUI()
    }
    
    func revivePlayer(player: PlayerMO) {
        GameManager.currentGame.revive(player)
        view.updateGameUI()
    }
    
    func didEndGame() {
        var winnerRole: Role = Role.none
        if GameManager.currentGame.aliveMafia == 0 {
            winnerRole = .villager
        } else if GameManager.currentGame.aliveMafia == GameManager.currentGame.aliveCivilians {
            winnerRole = .mob
        }
        view.endGame(winner: winnerRole)
    }
    
    func restartGame() {
        GameManager.currentGame.reviveAllKilledPlayers()
        view.restartGame()
    }
}
