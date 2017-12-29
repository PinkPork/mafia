//
//  PlayersListService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias CreatePlayersListCompletion = ((PlayersListMO?) -> Void)

class PlayersListService: BaseService {
    
    func createPlayersListWith(name: String, players: [PlayerMO], completion: CreatePlayersListCompletion) {
        let coreDataConnection = coreDatabase as! CoreDataConnection
        if let entity = try! coreDataConnection.getEntity(name: PlayersListMO.entityName) {
            let playerList = PlayersListMO(entity: entity , insertInto: coreDataConnection.managedContext)
            playerList.name = name
            playerList.addToPlayers(NSSet(array: players))
            if coreDatabase.save(playerList) {
                completion(playerList)
            } else {
                completion(nil)
            }
        }
    }
}
