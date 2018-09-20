//
//  GamePresenter.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/18/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol GameView: class, BaseView {
    func setPlayers(players: [Player])
    func addNewPlayer(player: Player)
    func deletePlayer(player: Player, indexPath: IndexPath)
    func updateGameUI()
    func endGame(winner: Role)
    func restartGame()
}

class GamePresenter {
    
    private unowned let view: GameView
    fileprivate let playerService: PlayerService
    
    var aliveCiviliansPlayerText: String? {
        if GameManager.currentGame.numberOfPlayersPlaying == 0 {
            return nil
        }
        return (gameCanStart ? "\("CIVILIANS_TITLE".localized()) \n \(GameManager.currentGame.aliveCivilians)" : nil)
    }
    
    var aliveMafiaPlayerText: String? {
        if GameManager.currentGame.numberOfPlayersPlaying == 0 {
            return nil
        }
        return (gameCanStart ? "\("MAFIA_TITLE".localized()) \n \(GameManager.currentGame.aliveMafia)" : nil)
    }
    
    var totalNumberOfPlayers: String? {
        if GameManager.currentGame.numberOfPlayersPlaying == 0 {
            return nil
        }
        return (gameCanStart ? "\("TOTAL_PLAYING_TITLE".localized()) \n \(GameManager.currentGame.numberOfPlayersPlaying)" : nil)
    }
    
    var selectedListName: String? {
        if !GameManager.currentGame.isSelectedListPlayers {
            return "LIST_PLAYER_NO_NAME".localized()
        }
        return GameManager.currentGame.listName
    }
    
    var gameCanStart: Bool {
        return (GameManager.currentGame.numberOfPlayersPlaying >= GameRules.minimumPlayers)
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
    
    func refreshRoles(players: [Player]) -> [Player] {
        if players.count >= GameRules.minimumPlayers {
            return RawPlayer.assignRandomRole(to: players)
        }
        players.forEach({ $0.role = .none })
        return players
    }
    
    func deletePlayer(player: Player, indexPath: IndexPath) {
        if GameManager.currentGame.removeForCurrentGame(player: player) {
            view.deletePlayer(player: player, indexPath: indexPath)
            view.updateGameUI()
        }
    }
    
    func kill(player: Player) {
        GameManager.currentGame.kill(player)
        view.updateGameUI()
        didEndGame()
    }
    
    func revivePlayer(player: Player) {
        GameManager.currentGame.revive(player)
        view.updateGameUI()
    }
    
    func didEndGame() {
        var winnerRole: Role = Role.none
        if GameManager.currentGame.aliveMafia == 0 {
            winnerRole = .villager
        } else if GameManager.currentGame.aliveMafia >= GameManager.currentGame.aliveCivilians {
            winnerRole = .mob
        }
        view.endGame(winner: winnerRole)
    }
    
    func restartGame() {
        GameManager.currentGame.reviveAllKilledPlayers()
        view.restartGame()
    }
    
    func addPlayerInCurrentGame(withName name: String) {
        let newPlayer: RawPlayer = RawPlayer(name: name)
        if GameManager.currentGame.addPlayerInSelectedList(newPlayer) {
            view.addNewPlayer(player: newPlayer)
        } else {
            view.showAlert(withTitle: "PLAYER_ALREADY_ADDED_TITLE".localized(), message: "PLAYER_ALREADY_ADDED_MESSAGE".localized(), preferredStyle: UIAlertController.Style.actionSheet, completionFirstAction: nil)
        }
    }
}
