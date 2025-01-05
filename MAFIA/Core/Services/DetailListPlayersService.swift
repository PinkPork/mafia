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
    
    func add(toList list: PlayerList, playerWithName name: String, completion: AddPlayerToListCompletion) {
        if let listMO = ListMO.reverseParse(fromList: list) {
            let playerMO = PlayerMO(name: name)
            listMO.addToPlayers(playerMO)

            if CoreDataConnection.shared.managedContext.save(list) {
                let Player = PlayerMO.parse(player: playerMO)                
                completion(Player)
                return
            }
        }
        completion(nil)
    }
    
    func remove(_ player: Player, fromList list: PlayerList, completion: RemovePlayerFromListCompletion) {

        if let listMO = ListMO.reverseParse(fromList: list) {
            if let playerMO = (listMO.players?.allObjects as? [PlayerMO])?.first(where: { $0.name == player.name }) {
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
