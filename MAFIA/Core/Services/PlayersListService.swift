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
    
    func createPlayersListWith(name: String, players: [PlayerMO] = [PlayerMO](), completion: CreatePlayersListCompletion) {
//        if let playerList: PlayersListMO = coreDatabase.loadObject(withId: PlayersListMO.entityName) {
//            playerList.name = name
//            playerList.players = NSSet(array: players)
//            if coreDatabase.save(playerList) {
//                completion(playerList)
//                return
//            }
//        }
//        completion(nil)
    }
}
