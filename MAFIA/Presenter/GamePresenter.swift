//
//  GamePresenter.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/18/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

protocol GameView: class {
    func setPlayers(players: [PlayerData])
    func addNewPlayer(player: PlayerData)
    func deletePlayer(player: PlayerData, indexPath: IndexPath)
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
            view.setPlayers(players: refreshRoles(players: players as! [PlayerMO]))
            view.updateGameUI()
        }
    }
    
    func refreshRoles(players: [PlayerData]) -> [PlayerData] {
        if players.count >= GameRules.minimumPlayers {
            return Player.assignRandomRole(to: players)
        }
        return players
    }
    
    func deletePlayer(player: PlayerData, indexPath: IndexPath) {
        playerService.deletePlayer(player: player) { [weak self] (success) in
            if success {
                self?.view.deletePlayer(player: player, indexPath: indexPath)
            }
        }
    }
    
    func kill(player: PlayerData) {
        GameManager.currentGame.kill(player)
        view.updateGameUI()
    }
    
    func revivePlayer(player: PlayerData) {
        GameManager.currentGame.revive(player)
        view.updateGameUI()
    }
    
    func didEndGame() {
        var winnerRole: Role = Role.none
        if GameManager.currentGame.aliveMafia == 0 {
            winnerRole = .civilian
        } else if GameManager.currentGame.aliveMafia == GameManager.currentGame.aliveCivilians {
            winnerRole = .mafia
        }
        view.endGame(winner: winnerRole)
    }
    
    func restartGame() {
        GameManager.currentGame.reviveAllKilledPlayers()
        view.restartGame()
    }
}
