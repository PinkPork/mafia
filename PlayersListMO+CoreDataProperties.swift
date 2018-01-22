//
//  PlayersListMO+CoreDataProperties.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//
//

import Foundation
import CoreData


extension PlayersListMO {
   
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayersListMO> {
        return NSFetchRequest<PlayersListMO>(entityName: "PlayersList")
    }

    @NSManaged public var name: String?
    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for players
extension PlayersListMO {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: PlayerMO)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: PlayerMO)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}
