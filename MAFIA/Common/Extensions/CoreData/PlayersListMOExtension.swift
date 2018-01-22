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

    convenience init(name: String) {
        self.init(entity: CoreDataConnection.shared.getEntity(withName: PlayersListMO.entityName)!, insertInto: CoreDataConnection.shared.managedContext)
        self.name = name
    }
    
    /// Converts PlayersListMO Core data object into a default playersList object
    /// - parameter playersList: Core data PlayersListMO object
    /// - returns: `PlayersList` default object
    class func parse(playersList: PlayersListMO) -> PlayersList {
        return RawPlayersList(name: playersList.name ?? "No name", players: parsePlayers(playersList.players))
    }
    
    
    /// Converts a set of Core data object players into an array of default players object
    /// - parameter listOfPlayers: Core data players object
    /// - returns: array of `Player` default objects
    class func parsePlayers(_ listOfPlayers: NSSet?) -> [Player] {
        var players: [Player] = [Player]()
        if let playersMO: [PlayerMO] = listOfPlayers?.toArray() {
            players.append(contentsOf: playersMO.map(PlayerMO.parse))
        }
        return players
    }

    /// Inverse of parse; Converts PlayersList object into a PlayersListMO Core data object by searching in the actual NSManagedContext the list given
    /// - parameter fromList: Default PlayersList object
    /// - returns: `PlayersListMO` Core data object
    class func reverseParse(fromList list: PlayersList) -> PlayersListMO? {
        let objects: [PlayersListMO] = CoreDataConnection.shared.managedContext.loadObjects(PlayersListMO.entityName, matching: "name == %@", params: [list.name])
        return objects.first
    }
}
