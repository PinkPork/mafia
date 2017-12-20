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
    @NSManaged public var name: String?
    var role: Role = .none
    
    class func assignRandomRole(to players: [PlayerMO]) -> [PlayerMO] {
        
        let mafiaRoles = [Role](repeatElement(Role.mafia, count: players.count / 3))
        let civiliansTotal = players.count - (mafiaRoles.count + GameRules.uniqueRoles.count)
        let civiliansRoles = [Role](repeatElement(.civilian, count: civiliansTotal))
        var allRoles = GameRules.uniqueRoles + mafiaRoles + civiliansRoles
        
        allRoles.shuffle()
        for (index, player) in players.enumerated() {
            player.role = allRoles[index]
        }
        return players.sorted(by: {$0.role.hashValue < $1.role.hashValue })
    }
}
