//
//  PlayersListMO+CoreDataClass.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PlayersListMO)
public class PlayersListMO: NSManagedObject, CoreDataIdentifier {
    
    // MARK: - Vars & Constants
    
    static var entityName: String = "PlayersList"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayersListMO> {
        return NSFetchRequest<PlayersListMO>(entityName: "PlayersList")
    }
    
    
    
    @NSManaged public var name: String
    @NSManaged public var players: NSSet?
    
    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: PlayerMO)
    
    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: PlayerMO)
    
    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)
    
    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)
    
}
