//
//  PlayersListMOExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

extension ListMO {
    // MARK: - Vars & Constants
    
    static var entityName: String = "PlayerList"

    convenience init(name: String) {
        self.init(entity: CoreDataConnection.shared.getEntity(withName: ListMO.entityName), insertInto: CoreDataConnection.shared.managedContext)
        self.name = name
    }
    
    /// Converts ListMO Core data object into a default PlayerList object
    /// - parameter list: Core data PlayersListMO object
    /// - returns: `list` default object
    class func parse(list: ListMO) -> PlayerList {
        return PlayerList(name: list.name ?? "No name", players: parsePlayers(list.players))
    }
    
    /// Converts a set of Core data object players into an array of default players object
    /// - parameter players: Core data players object
    /// - returns: array of `Player` default objects
    class func parsePlayers(_ listOfplayers: NSSet?) -> [Player] {
        var players: [Player] = [Player]()
        if let playersMO: [PlayerMO] = listOfplayers?.toArray() {
            players.append(contentsOf: playersMO.map(PlayerMO.parse))
        }
        return players
    }

    /// Inverse of parse; Converts PlayersList object into a PlayersListMO Core data object by searching in the actual NSManagedContext the list given
    /// - parameter fromList: Default PlayerList object
    /// - returns: `ListMO` Core data object
    class func reverseParse(fromList list: PlayerList) -> ListMO? {
        let objects: [ListMO] = CoreDataConnection.shared.managedContext.loadObjects(ofType: ListMO.entityName, matching: "name == %@", params: [list.name])
        return objects.first
    }
}
