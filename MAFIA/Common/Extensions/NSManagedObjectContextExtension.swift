//
//  NSManagedObjectContextExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 12/29/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import CoreData

extension NSManagedObjectContext: Database {
    
    /// Loads a collection of objects matching the Data Model name given in `modelName` and the query `query`
    /// - parameter modelName: The Data model name
    /// - parameter query: The query used to filter the collection
    /// - parameter params: Parameters used by query
    
    func loadObjects<Type>(_ modelName: String, matching query: String? = nil, params: [Any]? = nil) -> [Type] {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
        if let query = query {
            request.predicate = NSPredicate(format: query, argumentArray: params)
        }
        return try! self.fetch(request) as! [Type]
    }
    
    /// Loads an object
    /// - parameter id: The model entityDescription
    /// - returns: An NSManagedObject with the entityDescription given by the `id` parameter
    
    func loadObject<Type>(withId id: String) -> Type? {
        if let entityDescription = NSEntityDescription.entity(forEntityName: id, in: self) {
            return NSManagedObject(entity: entityDescription, insertInto: self) as? Type
        }
        return nil
    }
    
    /// Saves an object
    /// - parameter object: The object to be saved
    /// - returns: true if the object could be saved otherwise false
    
    func save<Type>(_ object: Type) -> Bool {
        do {
            try self.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    /// Deletes an object
    /// - parameter object: The object to be deleted
    /// - returns: true if the object could be deleted otherwise false
    
    func delete<Type>(_ object: Type) -> Bool {
        
        self.delete(object as! NSManagedObject)
        
        do {
            try self.save()
            return true
        } catch let error as NSError {
            print("Could not delete object. \(error), \(error.userInfo)")
            return false
        }
    }
}
