//
//  PlayerMO+CoreDataClass.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/19/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//
//

import Foundation
import CoreData



protocol CoreDataIdentifier {
    static var entityName: String { get }
}

@objc(PlayerMO)
public class PlayerMO: NSManagedObject, CoreDataIdentifier {
    
    // MARK: - Vars & Constants
    
    static var entityName: String = "Player"
    @NSManaged public var name: String
    var role: Role = .none
    
    /// Assigns a random role to each player with the following rules:
    /// 1. There is only **one king** on the game
    /// 2. There is only **one doctor** on the game
    /// 3. There is only **one sheriff** on the game
    /// 4. There **third part** of the players playing are **mafia**
    /// 5. The rest of players are **civilians**
    /// - parameter players: The players playing on the current game
    /// - returns: An Array of players, each of them with a random role setted
    
    class func assignRandomRole(to players: [PlayerMO]) -> [PlayerMO] {
        
        let mobRoles = [Role](repeatElement(Role.mob, count: players.count / 3))
        let villagersTotal = players.count - (mobRoles.count + GameRules.uniqueRoles.count)
        let villagersRoles = [Role](repeatElement(.villager, count: villagersTotal))
        var allRoles = GameRules.uniqueRoles + mobRoles + villagersRoles
        
        allRoles.shuffle()
        for (index, player) in players.enumerated() {
            player.role = allRoles[index]
        }
        return players
    }
}
