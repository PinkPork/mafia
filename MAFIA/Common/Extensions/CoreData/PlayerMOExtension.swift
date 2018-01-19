//
//  PlayerMOExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

extension PlayerMO {
    
    //MARK: - Vars & Constants
    static var entityName: String = "Player"

    convenience init(name: String) {
        self.init(entity: CoreDataConnection.shared.getEntity(withName: PlayerMO.entityName)!, insertInto: CoreDataConnection.shared.managedContext)
        self.name = name
    }
    
    class func parse(player: PlayerMO) -> Player {
        return RawPlayer(name: player.name ?? "No name")
    }

    class func reverseParse(fromPlayer player: Player) -> PlayerMO? {
        let objects: [PlayerMO] = CoreDataConnection.shared.managedContext.loadObjects(PlayerMO.entityName, matching: "name == %@", params: [player.name])
        return objects.first
    }
        
}
