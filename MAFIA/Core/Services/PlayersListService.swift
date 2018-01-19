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
typealias GetListCompletion = ((PlayersList?) -> Void)
typealias DeleteListPlayersCompletion = ((Bool) -> Void)

class PlayersListService: BaseService {
    
    func createPlayersListWith(name: String, players: [Player] = [Player](), completion: CreateListPlayersCompletion) {

        let playerList = PlayersListMO(name: name)
        playerList.players = players.map(PlayerMO.reverseParse).toNSSet()

        if CoreDataConnection.shared.managedContext.save(playerList) {
            completion(PlayersListMO.parse(playersList: playerList))
            return
        }
        
        completion(nil)
    }

    func getLists(completion: @escaping GetListPlayersCompletion) {
        let objects: [PlayersListMO] = CoreDataConnection.shared.managedContext.loadObjects(PlayersListMO.entityName)
        completion(objects.map(PlayersListMO.parse))
    }

    func getList(withName name: String, completion: GetListCompletion) {
        let objects: [PlayersListMO] = CoreDataConnection.shared.managedContext.loadObjects(PlayersListMO.entityName, matching: "name == %@", params: [name])
        completion(objects.map(PlayersListMO.parse).first)
    }

    func deleteList(list: PlayersList, completion: DeleteListPlayersCompletion) {
        if let playersListMO = PlayersListMO.reverseParse(fromList: list) {
            completion(CoreDataConnection.shared.managedContext.delete(playersListMO))
            return
        }
        completion(false)
    }
}
