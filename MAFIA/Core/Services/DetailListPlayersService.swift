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
    
    func add(toList list: PlayersList, playerWithName name: String, completion: AddPlayerToListCompletion) {
        if let listMO = PlayersListMO.reverseParse(fromList: list){
            let playerMO = PlayerMO(name: name)
            listMO.addToPlayers(playerMO)

            if CoreDataConnection.shared.managedContext.save(list) {
                let rawPlayer = PlayerMO.parse(player: playerMO)                
                completion(rawPlayer)
                return
            }
        }
        completion(nil)
    }
    
    func remove(_ player: Player, fromList list: PlayersList, completion: RemovePlayerFromListCompletion) {

        if let listMO = PlayersListMO.reverseParse(fromList: list) {
            if let playerMO = PlayerMO.reverseParse(fromPlayer: player) {
                listMO.removeFromPlayers(playerMO)
                if CoreDataConnection.shared.managedContext.save(listMO) {
                    completion(true)
                    return
                }
            }
        }
        completion(false)
    }

}
