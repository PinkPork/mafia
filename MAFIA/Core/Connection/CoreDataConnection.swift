//
//  CoreDataConnection.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/19/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit
import CoreData

class CoreDataConnection {
    
    // MARK: - Vars & Constants
    
    static let shared = CoreDataConnection()
    var managedContext: NSManagedObjectContext
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainerContext = appDelegate.persistentContainer.viewContext
        self.managedContext = persistantContainerContext
    }
    
    func getEntity(withName modelName: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: modelName , in: managedContext)
    }
}

