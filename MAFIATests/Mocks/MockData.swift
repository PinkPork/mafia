//
//  MockData.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import Foundation
import CoreData

struct MockData {
    struct Player {
        static let name: String = "Player Test"
        static let name1: String = "Player Test1"
        static let name2: String = "Player Test2"
        static let name3: String = "Player Test3"
        static let name4: String = "Player Test4"
        static let name5: String = "Player Test5"
        
        static var playerEntityName: NSEntityDescription {
            return CoreDataConnection.shared.getEntity(withName: PlayerMO.entityName)
        }
        
        static var Players: [String] {
            return [Player.name, Player.name1, Player.name2, Player.name3, Player.name4, Player.name5]
        }
    }
    
    struct PlayersList {
        static let name: String = "PlayerList Test"
        static let name1: String = "PlayerList Test1"
        static let name2: String = "PlayerList Test2"
        static let name3: String = "PlayerList Test3"
        static let name4: String = "PlayerList Test4"
        
        static var rawLists: [String] {
            return [PlayersList.name, PlayersList.name1, PlayersList.name2, PlayersList.name3, PlayersList.name4]
        }
    }
    
    struct CoreDataController {
        static var managedObjectContext: NSManagedObjectContext {
            guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else {
                return NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            }
            
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            } catch {
                print("Adding in-memory persistent store failed")
            }
            
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
            return managedObjectContext
        }
    }
}
