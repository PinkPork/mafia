//
//  PlayerService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/19/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias GetPlayersCompletion = (([PlayerMO]?) -> Void)
typealias SavePlayerCompletion = ((PlayerMO?) -> Void)
typealias DeletePlayerCompletion = ((Bool) -> Void)

class PlayerService: BaseService {
    
    func savePlayer(name: String, completion: SavePlayerCompletion) {
        if let object: PlayerMO = coreDatabase.loadObject(withId: PlayerMO.entityName) {
            object.setValue(name, forKey: "name")
            if coreDatabase.save(object) {
                completion(object)
            }
        }
    }
    
    func getPlayers(completion: @escaping GetPlayersCompletion) {
        let playerObjects: [PlayerMO] = coreDatabase.loadObjects(matching: PlayerMO.entityName)
        completion(playerObjects)
    }
    
    // TODO: Implement delete action on DatabaseProtocol
    func deletePlayer(player: PlayerMO, completion: DeletePlayerCompletion) {
//        completion(CoreDataConnection.shared.delete(object: player))
    }
}
