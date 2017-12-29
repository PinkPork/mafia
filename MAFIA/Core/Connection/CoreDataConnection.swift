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
    
    private func getObject(entity: NSEntityDescription) throws -> NSManagedObject {
        guard let managedContext = managedContext else {
            throw ErrorCoreData.invalidManagedContext
        }
        return NSManagedObject(entity: entity, insertInto: managedContext)
    }
    
    private func getObject(fromEntityName name: String) throws -> NSManagedObject {
        guard let entity = try getEntity(name: name) else{
            throw ErrorCoreData.invalidEntity
        }
        
        let object = try getObject(entity: entity)
        return object
    }
    
    private func fetchRequest(entityName: String) -> [NSManagedObject] {
        guard let managedContext = managedContext else {
            return [NSManagedObject]()
        }
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        return try! managedContext.fetch(request)
    }
    
   private func save<T>(object: T) -> Bool {
        guard let managedContext = managedContext else {
            print(ErrorCoreData.invalidManagedContext.localizedDescription)
            return false
        }
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    private func delete<T>(object: T) -> Bool {
        guard let managedContext = managedContext else {
            print(ErrorCoreData.invalidManagedContext.localizedDescription)
            return false
        }
        
        managedContext.delete(object as! NSManagedObject)
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
}


extension CoreDataConnection: Database {
    
    func loadObject<Type>(withId id: String) -> Type? {
        return try! getObject(fromEntityName: id) as! Type
    }
    
    func loadObjects<Type>(matching query: String) -> [Type] {
        return fetchRequest(entityName: query) as! [Type]
    }
    
    func save<Type>(_ object: Type) -> Bool {
        return save(object: object)
    }
}
