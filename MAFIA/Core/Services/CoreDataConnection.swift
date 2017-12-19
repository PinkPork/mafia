//
//  CoreDataConnection.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/19/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit
import CoreData

enum ErrorCoreData: Error {
    case invalidManagedContext,
    invalidEntity
}

class CoreDataConnection {
    
    // MARK: - Vars & Constants
    
    static let shared = CoreDataConnection()
    var managedContext: NSManagedObjectContext?
    
    init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.managedContext = appDelegate.persistentContainer.viewContext
        }
    }
    
    func getEntity(name: String) throws -> NSEntityDescription? {
        guard let managedContext = managedContext else {
            throw ErrorCoreData.invalidManagedContext
        }
        
        return NSEntityDescription.entity(forEntityName: name , in: managedContext)
    }
    
    func getObject(entity: NSEntityDescription) throws -> NSManagedObject {
        guard let managedContext = managedContext else {
            throw ErrorCoreData.invalidManagedContext
        }
        return NSManagedObject(entity: entity, insertInto: managedContext)
    }
    
    func getObject(fromEntityName name: String) throws -> NSManagedObject {
        guard let entity = try getEntity(name: name) else{
            throw ErrorCoreData.invalidEntity
        }
        
        let object = try getObject(entity: entity)
        return object
    }
    
    func fetchRequest(entityName: String) throws -> [NSManagedObject] {
        guard let managedContext = managedContext else {
            throw ErrorCoreData.invalidManagedContext
        }
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        return try managedContext.fetch(request)
    }
    
    func save<T>(object: T) -> T? {
        guard let managedContext = managedContext else {
            print(ErrorCoreData.invalidManagedContext.localizedDescription)
            return nil
        }
        
        do {
            try managedContext.save()
            return object
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
}
