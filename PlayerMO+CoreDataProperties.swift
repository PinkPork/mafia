//
//  PlayerMO+CoreDataProperties.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//
//

import Foundation
import CoreData


extension PlayerMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerMO> {
        return NSFetchRequest<PlayerMO>(entityName: "Player")
    }

    @NSManaged public var name: String?
//    @NSManaged public var playersList: NSSet?

}

// MARK: Generated accessors for playersList
extension PlayerMO {

    @objc(addPlayersListObject:)
    @NSManaged public func addToPlayersList(_ value: PlayersListMO)

    @objc(removePlayersListObject:)
    @NSManaged public func removeFromPlayersList(_ value: PlayersListMO)

    @objc(addPlayersList:)
    @NSManaged public func addToPlayersList(_ values: NSSet)

    @objc(removePlayersList:)
    @NSManaged public func removeFromPlayersList(_ values: NSSet)

}
