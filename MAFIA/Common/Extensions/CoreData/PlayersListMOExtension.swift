//
//  PlayersListMOExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

extension PlayersListMO {
    //MARK: - Vars & Constants
    
    static var entityName: String = "PlayersList"
    
    class func parse(playersList: PlayersListMO) -> PlayersList {
        return RawPlayersList(name: playersList.name ?? "No name", players: parsePlayers(playersList.players))
    }
    
    class func parsePlayers(_ listOfPlayers: NSSet?) -> [Player] {
        var players: [Player] = [Player]()
        if let playersMO: [PlayerMO] = listOfPlayers?.toArray() {
            players.append(contentsOf: playersMO.map(PlayerMO.parse))
        }
        return players
    }
}
