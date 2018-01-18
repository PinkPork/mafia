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
public class PlayerMO: NSManagedObject, CoreDataIdentifier, PlayerData {

    // MARK: - Vars & Constants
    
    static var entityName: String = "Player"
    @NSManaged public var name: String
    var role: Role = .none
    
}
