//
//  DetailListPlayersService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/5/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias AddPlayerToListCompletion = ((PlayerMO?) -> Void)
typealias RemovePlayerFromListCompletion = ((Bool) -> Void)

class DetailListPlayersService {
    
    func add(toList list: PlayersListMO, playerWithName player: String, completion: AddPlayerToListCompletion) {
        if let playerEntity = CoreDataConnection.shared.getEntity(withName: PlayerMO.entityName) {
            let rawPlayer = PlayerMO(entity: playerEntity, insertInto: CoreDataConnection.shared.managedContext)
            rawPlayer.name = player
            list.addToPlayers(rawPlayer)
            if CoreDataConnection.shared.managedContext.save(list) {
                completion(rawPlayer)
                return
            }
            completion(nil)
        }
    }
    
    func remove(_ player: PlayerMO, fromList list: PlayersListMO, completion: RemovePlayerFromListCompletion) {
        list.removeFromPlayers(player)
        completion(CoreDataConnection.shared.managedContext.save(list))
    }
}
