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

    class func reverseParse(fromList list: PlayersList) -> PlayersListMO? {
        let objects: [PlayersListMO] = CoreDataConnection.shared.managedContext.loadObjects(PlayersListMO.entityName, matching: "name == %@", params: [list.name])
        return objects.first
    }
}
