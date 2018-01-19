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
    static var entityName: String = "PlayersList"
    
    class func parse(player: PlayerMO) -> Player {
        return RawPlayer(name: player.name ?? "No name")
    }
        
}
