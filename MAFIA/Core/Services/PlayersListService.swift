//
//  PlayersListService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias CreatePlayersListCompletion = ((PlayersListMO?) -> Void)

class PlayersListService {
    
    func createPlayersListWith(name: String, players: [PlayerMO], completion: CreatePlayersListCompletion) {
        if let entity = try! CoreDataConnection.shared.getEntity(name: PlayersListMO.entityName) {
            let playerList = PlayersListMO(entity: entity , insertInto: CoreDataConnection.shared.managedContext)
            playerList.name = name
            playerList.addToPlayers(NSSet(array: players))
            completion(CoreDataConnection.shared.save(object: playerList))
        }
    }
}
