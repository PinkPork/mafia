//
//  DetailListPlayersService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/5/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias AddPlayersToListCompletion = (([PlayerMO]?) -> Void)
typealias RemovePlayerFromListCompletion = ((Bool) -> Void)

class DetailListPlayersService {
    
    func add(toList list: PlayersListMO, playersWithName players: [String], completion: AddPlayersToListCompletion) {
        if let playerEntity = CoreDataConnection.shared.getEntity(withName: PlayerMO.entityName) {
            let playersToAdd = players.map { (name) -> PlayerMO in
                let rawPlayer = PlayerMO(entity: playerEntity, insertInto: CoreDataConnection.shared.managedContext)
                rawPlayer.name = name
                return rawPlayer
            }
            list.addToPlayers(NSSet(array: playersToAdd))
            if CoreDataConnection.shared.managedContext.save(list) {
                completion(playersToAdd)
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
