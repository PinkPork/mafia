//
//  BaseService.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

class BaseService {
    
    internal let coreDatabase: Database
    
    init() {
       self.coreDatabase = CoreDataConnection()
    }
}
