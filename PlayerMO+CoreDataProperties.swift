//
//  PlayerMO+CoreDataProperties.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 1/27/18.
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
    @NSManaged public var lists: ListMO?

}
