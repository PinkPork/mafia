//
//  PlayersListMO+CoreDataProperties.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 1/27/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//
//

import Foundation
import CoreData

extension ListMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListMO> {
        return NSFetchRequest<ListMO>(entityName: "PlayerList")
    }

    @NSManaged public var name: String?
    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for players
extension ListMO {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: PlayerMO)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: PlayerMO)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}
