//
//  ListService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias CreateListCompletion = ((List?) -> Void)
typealias GetListsCompletion = (([List]?) -> Void)
typealias GetListCompletion = ((List?) -> Void)
typealias DeleteListCompletion = ((Bool) -> Void)

class ListService: BaseService {
    
    func createListWith(name: String, players: [Player] = [Player](), completion: CreateListCompletion) {

        let playerList = ListMO(name: name)
        playerList.players = players.flatMap(PlayerMO.reverseParse).toNSSet()

        if CoreDataConnection.shared.managedContext.save(playerList) {
            completion(ListMO.parse(list: playerList))
            return
        }
        
        completion(nil)
    }

    func getLists(completion: @escaping GetListsCompletion) {
        let objects: [ListMO] = CoreDataConnection.shared.managedContext.loadObjects(ofType: ListMO.entityName)
        completion(objects.map(ListMO.parse))
    }

    func getList(withName name: String, completion: GetListCompletion) {
        let objects: [ListMO] = CoreDataConnection.shared.managedContext.loadObjects(ofType: ListMO.entityName, matching: "name == %@", params: [name])
        completion(objects.map(ListMO.parse).first)
    }

    func deleteList(list: List, completion: DeleteListCompletion) {
        if let playersListMO = ListMO.reverseParse(fromList: list) {
            completion(CoreDataConnection.shared.managedContext.delete(playersListMO))
            return
        }
        completion(false)
    }
}
