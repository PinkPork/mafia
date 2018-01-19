//
//  DetailListPlayersService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/5/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias AddPlayerToListCompletion = ((Player?) -> Void)
typealias RemovePlayerFromListCompletion = ((Bool) -> Void)

class DetailListPlayersService {
    
    func add(toList list: PlayersList, playerWithName player: String, completion: AddPlayerToListCompletion) {
        if let playerEntity = CoreDataConnection.shared.getEntity(withName: PlayerMO.entityName) {
            let rawPlayer = PlayerMO(entity: playerEntity, insertInto: CoreDataConnection.shared.managedContext)
            rawPlayer.name = player
            
            // TODO: Set the parseInverse
//            list.addToPlayers(rawPlayer)
            if CoreDataConnection.shared.managedContext.save(list) {
                completion(PlayerMO.parse(player: rawPlayer))
                return
            }
            completion(nil)
        }
    }
    
    func remove(_ player: Player, fromList list: PlayersList, completion: RemovePlayerFromListCompletion) {
//        list.removeFromPlayers(player as! PlayerMO)
        completion(CoreDataConnection.shared.managedContext.save(list))
    }
}
