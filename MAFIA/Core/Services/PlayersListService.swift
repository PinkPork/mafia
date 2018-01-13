//
//  PlayersListService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias CreateListPlayersCompletion = ((PlayersListMO?) -> Void)
typealias GetListPlayersCompletion = (([PlayersListMO]?) -> Void)
typealias DeleteListPlayersCompletion = ((Bool) -> Void)

class PlayersListService: BaseService {
    
    func createPlayersListWith(name: String, players: [PlayerMO] = [PlayerMO](), completion: CreateListPlayersCompletion) {
        if let playerEntity = CoreDataConnection.shared.getEntity(withName: PlayersListMO.entityName) {
            let playerList = PlayersListMO(entity: playerEntity, insertInto: CoreDataConnection.shared.managedContext)
            playerList.name = name
            playerList.players = players.toNSSet()
            if CoreDataConnection.shared.managedContext.save(playerList) {
                completion(playerList)
                return
            }
        }
        completion(nil)
    }
    
    func getPlayers(completion: @escaping GetListPlayersCompletion) {
        completion(CoreDataConnection.shared.managedContext.loadObjects(PlayersListMO.entityName))
    }
    
    func deleteList(list: PlayersListMO, completion: DeleteListPlayersCompletion) {
         completion(CoreDataConnection.shared.managedContext.delete(list))
    }
}
