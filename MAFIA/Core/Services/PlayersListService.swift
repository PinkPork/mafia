//
//  PlayersListService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias CreateListPlayersCompletion = ((PlayersList?) -> Void)
typealias GetListPlayersCompletion = (([PlayersList]?) -> Void)
typealias DeleteListPlayersCompletion = ((Bool) -> Void)

class PlayersListService: BaseService {
    
    func createPlayersListWith(name: String, players: [Player] = [Player](), completion: CreateListPlayersCompletion) {
        if let playerEntity = CoreDataConnection.shared.getEntity(withName: PlayersListMO.entityName) {
            let playerList = PlayersListMO(entity: playerEntity, insertInto: CoreDataConnection.shared.managedContext)
            playerList.name = name
            
            playerList.players = players.map({ (player) -> PlayerMO in
                let playerEntity = CoreDataConnection.shared.getEntity(withName: PlayerMO.entityName)
                let playerMO = PlayerMO(entity: playerEntity!, insertInto: CoreDataConnection.shared.managedContext)
                playerMO.name = player.name
                return playerMO
            }).toNSSet()
            
            if CoreDataConnection.shared.managedContext.save(playerList) {
                completion(PlayersListMO.parse(playersList: playerList))
                return
            }
        }
        completion(nil)
    }
    
    func getPlayers(completion: @escaping GetListPlayersCompletion) {
        completion(CoreDataConnection.shared.managedContext.loadObjects(PlayersListMO.entityName).map(PlayersListMO.parse))
    }
    
    func deleteList(list: PlayersList, completion: DeleteListPlayersCompletion) {
         completion(CoreDataConnection.shared.managedContext.delete(list))
    }
}
