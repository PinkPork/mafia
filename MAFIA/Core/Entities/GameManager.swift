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
    
    private var selectedListPlayers: PlayersListMO?
    private var eliminatedPlayers: [PlayerMO] = [PlayerMO]()
    
    private init() {
        
    }
    
    var playersPlaying: [PlayerMO]? {
        return selectedListPlayers?.players?.toArray()
    }
    
    var listName: String? {
        return selectedListPlayers?.name
    }
    
    var numberOfPlayersPlaying: Int {
        return playersPlaying?.count ?? 0
    }
    
    /// Returns the number of civilians team players that are currently playing and are live
    var aliveCivilians: Int {
        get {
            let mafiaPlayers = numberOfPlayersPlaying / 3     //Esto sirve para calcular la cantidad de mafiosos.
            var civiliansPlaying = numberOfPlayersPlaying - mafiaPlayers
            civiliansPlaying = eliminatedPlayers.reduce(civiliansPlaying, {(result, player) -> Int in
                return player.role != .mafia ? result - 1 : result
            })
            
            return civiliansPlaying
        }
    }
    
    /// Returns the number of mafia team players that are playing and are alive
    var aliveMafia: Int {
        get {
            var mafiaPlayers = numberOfPlayersPlaying / 3
            mafiaPlayers = eliminatedPlayers.reduce(mafiaPlayers, {(result, player) -> Int in
                return player.role == .mafia ? result - 1 : result
            })
            return mafiaPlayers
        }
    }
    
    func setSelectedList(listPlayers: PlayersListMO) {
        selectedListPlayers = listPlayers
    }
    
    /// Adds a player to the `eliminatedPlayers` array.
    /// parameter player: The player to be kill from the current game
    func kill(_ player: PlayerMO) {
        eliminatedPlayers.append(player)
    }
    
    /// Removes a player from the `eliminatedPlayers` array
    /// parameter player: The player to be revived from the current game
    func revive(_ player: PlayerMO) {
        if let index = eliminatedPlayers.index(of: player) {
            eliminatedPlayers.remove(at: index)
        }
    }
    
    func reviveAllKilledPlayers() {
        eliminatedPlayers.removeAll()
    }
    
}
