//
//  GamePresenter.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/18/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//



/**

 var selectedListPlayers: PlayersListMO?
 var eliminatedPlayers: [PlayerMO] = [PlayerMO]()
 
 var playersPlaying: Int {
 return selectedListPlayers?.players?.count ?? 0
 }
 
 var aliveCivilians: Int {
 get {
 let mafiaPlayers = playersPlaying / 3     //Esto sirve para calcular la cantidad de mafiosos.
 var civiliansPlaying = playersPlaying - mafiaPlayers
 civiliansPlaying = eliminatedPlayers.reduce(civiliansPlaying, {(result, player) -> Int in
 return player.role != .mafia ? result - 1 : result
 })
 
 return civiliansPlaying
 }
 }
 
 var aliveMafia: Int {
 get {
 var mafiaPlayers = playersPlaying / 3
 mafiaPlayers = eliminatedPlayers.reduce(mafiaPlayers, {(result, player) -> Int in
 return player.role == .mafia ? result - 1 : result
 })
 return mafiaPlayers
 }
 }
 
*/

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
    
    func eliminatePlayer(player: PlayerMO) {
        GameManager.currentGame.eliminatePlayer(player)
        view.updateGameUI()
    }
    
    func revivePlayer(player: PlayerMO) {
        GameManager.currentGame.removeFromEliminatedPlayers(player)
        view.updateGameUI()
    }
    
    func didEndGame() {
        var winnerRole: Role = Role.none
        if GameManager.currentGame.aliveMafia == 0 {
            winnerRole = .civilian
        } else if GameManager.currentGame.aliveMafia == GameManager.currentGame.aliveMafia {
            winnerRole = .mafia
        }
        view.endGame(winner: winnerRole)
    }
    
    func restartGame() {
        GameManager.currentGame.removeAllEliminatedPlayers()
        view.restartGame()
    }
}