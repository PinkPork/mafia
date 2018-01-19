//
//  PlayerService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/19/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias GetPlayersCompletion = (([Player]?) -> Void)
typealias GetPlayerCompletion = ((Player?) -> Void)
typealias SavePlayerCompletion = ((Player?) -> Void)
typealias DeletePlayerCompletion = ((Bool) -> Void)

class PlayerService: BaseService {
    
    func savePlayer(name: String, completion: SavePlayerCompletion) {
        
        if let playerEntity = CoreDataConnection.shared.getEntity(withName: PlayerMO.entityName) {
            let object: PlayerMO = PlayerMO(entity: playerEntity , insertInto: CoreDataConnection.shared.managedContext)
            object.name = name
            if CoreDataConnection.shared.managedContext.save(object) {
                completion(PlayerMO.parse(player: object))
            }
        }
    }
    
    func getPlayers(completion: @escaping GetPlayersCompletion) {
        completion(CoreDataConnection.shared.managedContext.loadObjects(PlayerMO.entityName).map(PlayerMO.parse))
    }
    
    func getPlayer(withName name: String, completion: GetPlayerCompletion) {
        completion(CoreDataConnection.shared.managedContext.loadObjects(PlayerMO.entityName, matching: "name == %@", params: [name]).map(PlayerMO.parse).first)
    }
    
    func deletePlayer(player: Player, completion: DeletePlayerCompletion) {
        completion(CoreDataConnection.shared.managedContext.delete(player))
    }
}
