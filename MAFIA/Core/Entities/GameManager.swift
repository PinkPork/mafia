//
//  GameManager.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/4/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

class GameManager {
    
    // MARK: - Vars & Constants
    
    static let currentGame = GameManager()
    
    private var selectedListPlayers: PlayerList?
    private var eliminatedPlayers: [Player] = [Player]()
    
    private init() {
        
    }
    
    var playersPlaying: [Player]? {
        return selectedListPlayers?.players
    }
    
    var listName: String? {
        return selectedListPlayers?.name
    }
    
    var numberOfPlayersPlaying: Int {
        return playersPlaying?.count ?? 0
    }
    
    var isSelectedListPlayers: Bool {
        return selectedListPlayers != nil
    }
    
    var refreshWithoutPopup: Bool = false
    
    /// Returns the number of civilians team players that are currently playing and are live
    var aliveCivilians: Int {
            let mafiaPlayers = numberOfPlayersPlaying / 3 // Esto sirve para calcular la cantidad de mafiosos.
            var civiliansPlaying = numberOfPlayersPlaying - mafiaPlayers
            civiliansPlaying = eliminatedPlayers.reduce(civiliansPlaying, {(result, player) -> Int in
                return player.role != .mob ? result - 1 : result
            })
            
            return civiliansPlaying        
    }
    
    /// Returns the number of mafia team players that are playing and are alive
    var aliveMafia: Int {
            var mafiaPlayers = numberOfPlayersPlaying / 3
            mafiaPlayers = eliminatedPlayers.reduce(mafiaPlayers, {(result, player) -> Int in
                return player.role == .mob ? result - 1 : result
            })
            return mafiaPlayers
    }

    /// Returns the number of players alive in the current game
    var numberOfAlivePlayers: Int {
        return numberOfPlayersPlaying - eliminatedPlayers.count
    }

    /// Returns the number of players death in the current game
    var numberOfEliminatedPlayers: Int {
        return eliminatedPlayers.count
    }
    
    func setSelectedList(listPlayers: PlayerList) {
        refreshWithoutPopup = false
        selectedListPlayers = listPlayers
    }
    
    /// Adds a player to the `eliminatedPlayers` array.
    /// parameter player: The player to be kill from the current game
    func kill(_ player: Player) {
        eliminatedPlayers.append(player)
    }
    
    /// Removes a player from the `eliminatedPlayers` array
    /// parameter player: The player to be revived from the current game
    func revive(_ player: Player) {
        if let index = eliminatedPlayers.firstIndex(where: { $0.name == player.name }) {
            eliminatedPlayers.remove(at: index)
        }
    }

    /// Removes all players from the `eliminatedPlayers` array
    func reviveAllKilledPlayers() {
        eliminatedPlayers.removeAll()
    }

    /// Removes a players from the playersPlaying array so that player wouldn't appear any more in the current game.
    /// **NOTE:** If you want to play again with the player you should select again the list.
    /// returns: `true` if the player could be deleted from the current game, otherwise `false`
    func removeForCurrentGame(player: Player) -> Bool {
        if let index = selectedListPlayers?.players.firstIndex(where: { $0.name == player.name }) {
            selectedListPlayers?.players.remove(at: index)
            return true
        }
        return false
    }

    /// Checks if the player had been killed
    /// returns: `true` if the player had been killed, otherwise `false`
    func checkForKilledPlayers(player: Player) -> Bool {
        let filteredPlayer = eliminatedPlayers.filter { (playerToSearch) -> Bool in
            if player.name == playerToSearch.name {
                return true
            } else {
                return false
            }
        }
        if filteredPlayer.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    func addPlayerInSelectedList(_ player: Player) -> Bool {
        guard selectedListPlayers?.players.filter({ $0.name == player.name }).count == 0 else {
            return false
        }

        selectedListPlayers?.players.append(player)
        return true
        
    }
    
}
