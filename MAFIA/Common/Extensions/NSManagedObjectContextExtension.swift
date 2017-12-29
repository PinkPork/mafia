//
//  NSManagedObjectContextExtension.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 12/29/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import CoreData

extension NSManagedObjectContext: Database {
    func loadObjects<Type>(_ modelName: String, matching query: String? = nil, params: [Any]? = nil) -> [Type] {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
        if let query = query {
            request.predicate = NSPredicate(format: query, argumentArray: params)
        }
        return try! self.fetch(request) as! [Type]
    }
    
    
    func loadObject<Type>(withId id: String) -> Type? {
        if let entityDescription = NSEntityDescription.entity(forEntityName: id , in: self) {
            return NSManagedObject(entity: entityDescription, insertInto: self) as? Type
        }
        return nil
    }
    
    
    func save<Type>(_ object: Type) -> Bool {
        do {
            try self.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
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
