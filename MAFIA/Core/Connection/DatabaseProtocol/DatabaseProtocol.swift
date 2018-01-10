//
//  DatabaseProtocol.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//
//
//
// This protocol is intended to be used in every Database of we are using like CoreData, Firebase or something else,
// the idea is to be conformed by the object. For example in this case it is conformed by NSManagedObjectContext
//

import Foundation
import CoreData

typealias Database = ReadableDatabase & WritableDatabase

protocol ReadableDatabase {
    func loadObjects<Type>(_ modelName: String, matching query: String?, params: [Any]?) -> [Type]
    func loadObject<Type>(withId id: String) -> Type?
}

protocol WritableDatabase {
    func save<Type>(_ object: Type) -> Bool
    func delete<Type>(_ object: Type) -> Bool
}
