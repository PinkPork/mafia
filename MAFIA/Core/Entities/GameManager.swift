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
        if let players = selectedListPlayers?.players {
            return Array(players) as? [PlayerMO]
        }
        return nil
    }
    
    var listName: String? {
        return selectedListPlayers?.name
    }
    
    var numberOfPlayersPlaying: Int {
        return selectedListPlayers?.players?.count ?? 0
    }
    
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
    
    func eliminatePlayer(_ player: PlayerMO) {
        eliminatedPlayers.append(player)
    }
    
    func removeFromEliminatedPlayers(_ player: PlayerMO) {
        if let index = eliminatedPlayers.index(of: player) {
            eliminatedPlayers.remove(at: index)
        }
    }
    
    func removeAllEliminatedPlayers() {
        eliminatedPlayers.removeAll()
    }
    
}
