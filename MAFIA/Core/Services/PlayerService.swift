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

class PlayerService {
    
    func savePlayer(name: String, completion: SavePlayerCompletion) {
        let object = try? CoreDataConnection.shared.getObject(fromEntityName: PlayerMO.entityName)
        object?.setValue(name, forKey: "name")
        completion(CoreDataConnection.shared.save(object: object) as? PlayerMO)
    }
    
    func getPlayers(completion: @escaping GetPlayersCompletion) {
        if let playerObjects = try? CoreDataConnection.shared.fetchRequest(entityName: PlayerMO.entityName) {
            completion(playerObjects as? [PlayerMO])
        }
        completion(nil)
    }
    
    func deletePlayer(player: PlayerMO, completion: DeletePlayerCompletion) {        
            completion(CoreDataConnection.shared.delete(object: player))
    }
}
